
# 🚀 Aggregator Node with IPFS Kubo

Welcome to the **Aggregator Node with IPFS Kubo** project! This repository contains a Docker-based setup for running an **Vola Aggregator Node** alongside an **IPFS Kubo** instance. This setup is designed for seamless integration and ensures reliable performance.

## 📂 Repository Structure

-   **`docker-compose.yml`**
    
    -   Defines the services: `ipfs-kubo` and `aggregator-node`.
    -   Configures volume mappings, environment variables, and dependencies.
-   **`entry.sh`**
    
    -   Handles the initialization process for the Aggregator Node.
    -   Checks for required keys and generates them if missing.
    -   Starts the Aggregator Node with the provided configurations.
-   **`.env`**
    
    -   Contains environment variables for configuring the services.

## 🛠️ Setup Instructions

Follow these steps to get started:

### 1️⃣ Prerequisites

-   Install [Docker](https://docs.docker.com/get-docker/).
-   Clone this repository to your local machine.

### 2️⃣ Configuration

1.  **Environment Variables**:
    
    -   Update the `.env` file with appropriate values:
        
        ```env
        LISTEN_IP=0.0.0.0
        LISTEN_PORT=1331
        ACCOUNT=YourAccount
        SURI=YourSecretPhrase
        KEYSTORE_PASSWORD=YourPassword
        
        ```
        
2.  **Volumes**:
    
    -   Ensure the necessary volumes are set up as specified in `docker-compose.yml`.

### 3️⃣ Run the Services

Start the services using Docker Compose:

```bash
docker-compose up -d

```

### 4️⃣ Verify the Setup

-   Check if the `ipfs-kubo` and `aggregator-node` containers are running:
    

docker ps

```
- Logs can be checked for each service:
  ```bash
docker logs ipfs-kubo

```

```bash
docker logs aggregator-node

```

## 📝 Detailed Descriptions

### IPFS Kubo

-   **Ports**:
    
    -   `4001`: Peer-to-peer connections.
    -   `127.0.0.1:8080`: HTTP gateway.
    -   `127.0.0.1:5001`: API access.
-   **Data Directory**:
    
    -   Maps `./ipfs-data` to `/data/ipfs` in the container.

### Aggregator Node

-   **Entrypoint**:
    
    -   Uses `entry.sh` for setting up and starting the node.
-   **Features**:
    
    -   Automatically generates a key if `SURI` or `ACCOUNT` is missing.
    -   Securely inserts keys into the keystore.
-   **Environment Variables**:
    
    -   `LISTEN_IP`: IP address the node listens on.
    -   `LISTEN_PORT`: Port the node listens on.
    -   `ACCOUNT`: Address of the owner account.
    -   `SURI`: Secret phrase for account key generation.
    -   `KEYSTORE_PASSWORD`: Password for the keystore.

## 🚨 Troubleshooting

1.  **Missing Keys**:
    
    -   If `SURI` or `ACCOUNT` is missing, the script in `entry.sh` will automatically generate them and print the details in the logs.
2.  **Failed Node Start**:
    
    -   Check if the ports are already in use.
    -   Validate the environment variables in `.env`.
3.  **Container Restart**:
    
    -   The services are configured with `restart: unless-stopped`. If a service stops, it will attempt to restart automatically.

## 🎉 Success Message

Once the setup is complete, you should see the following success message in the logs:

```
Running in dev mode...

```
