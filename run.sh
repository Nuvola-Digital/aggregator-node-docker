#!/usr/bin/env bash

NGINX_CONFIG_DIR="./nginx/conf.d"


# Path to the environment check script
CHECK_SCRIPT="env-check.sh"

# Run the environment check script
bash "$CHECK_SCRIPT"

# Capture the exit code
EXIT_CODE=$?

if [[ $EXIT_CODE -ne 0 ]]; then
    echo "Please fix the .env file before proceeding."
    exit 1
fi

# Source the .env file to set variables
set -o allexport
source .env
set +o allexport
# Check if required variables are set
if [[ -z "$GATEWAY_DOMAIN" ]]; then
    echo "Error: GATEWAY_DOMAIN is not set. Please export GATEWAY_DOMAIN or set it before running the script."
    exit 1
fi

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first." >&2
    exit 1
fi

if ! docker info &>/dev/null; then
    echo "Docker is installed but not running. Please start the Docker service."
    read -p "Do you want to try starting Docker? (y/n): " start_docker
    if [[ $start_docker == [Yy] ]]; then
        if [[ "$(uname -s)" == "Linux" ]]; then
            systemctl start docker
        elif [[ "$(uname -s)" == "Darwin" ]]; then
            open --background -a Docker
        else
            echo "Please manually start Docker."
            exit 1
        fi
        
        # Re-check Docker status
        if ! docker info &>/dev/null; then
            echo "Failed to start Docker. Please manually start it."
            exit 1
        fi
    else
        exit 1
    fi
fi

# Create necessary directories
mkdir -p "$NGINX_CONFIG_DIR"

# Get user's email address
echo -en "\nEnter your email address (Let's Encrypt will send you certificate expiration reminders)\n>>>"
read -r EMAIL

# Pull the latest Certbot image
docker pull certbot/certbot:latest
# echo "Creating Volume for certbot"
# docker volume create certbot-data
echo "Trying to obtain SSL certificate for domain $GATEWAY_DOMAIN..."
docker run --rm \
-p 80:80 \
-v "$(pwd)/certbot/config:/etc/letsencrypt" \
certbot/certbot:latest certonly \
--standalone \
--noninteractive \
--agree-tos \
--preferred-challenges http \
--email "$EMAIL" \
-d "$GATEWAY_DOMAIN"

if [ $? -ne 0 ]; then
    echo -e "\nFailed. Trying with manual DNS-01 validation..."

    docker run -it --rm \
    --name certbot \
    -v "$(pwd)/certbot/config:/etc/letsencrypt" \
    certbot/certbot certonly \
    --manual \
    --preferred-challenges dns \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    -d "$GATEWAY_DOMAIN"

    if [ $? -ne 0 ]; then
        echo "Failed to obtain SSL certificate. Please try again."
        exit 1
    fi
fi

echo "Certificate obtained successfully. Setting up NGINX container..."

# Create a basic NGINX configuration for SSL
cat > "$NGINX_CONFIG_DIR/default.conf" <<EOL
server {
    listen 80;
    server_name $GATEWAY_DOMAIN;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name $GATEWAY_DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$GATEWAY_DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$GATEWAY_DOMAIN/privkey.pem;

    location / {
        proxy_pass http://192.168.1.5:1331;
    }
}

EOL



# Remove the Certbot image
echo "Removing Certbot Docker image..."
docker rmi certbot/certbot:latest


echo "Restarting Docker Compose..."
docker compose up 