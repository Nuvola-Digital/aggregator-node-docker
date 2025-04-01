
# Vola Aggregator Node

This repository contains scripts for easy orchestration of the Vola Aggregator Node, including automated SSL certificate management and Nginx setup.

## Prerequisites

Before you begin, ensure you have the following installed:

-   **Docker:** For containerization.
    
-   **Docker Compose:** For orchestrating multi-container setups.
    
-   **A Public Domain:** Required for setting up SSL.
    

## Quick Start

1.  **Clone the Repository:** Clone the Vola Aggregator Node Docker repository to your local machine:
    
    ```bash
    git clone https://github.com/Nuvola-Digital/aggregator-node-docker
    cd aggregator-node-docker
    
    ```
    
2.  **Configure Environment Variables:**
    
    -   Copy the _.env.example_ file to _.env_:
        
        ```bash
        cp .env.example .env
        
        ```
        
    -   Open the _.env_ file and update the following variables:
        
        -   **LISTEN_ADDR**: IP address interface the node listens on. Default is `0.0.0.0`.
            
        -   **LISTEN_PORT**: Port the node listens on. Default is `1331`.
            
        -   **ACCOUNT**: Account address of the owner account.
            
        -   **SURI**: Secret phrase for owner account.
            
        -   **KEYSTORE_PASSWORD**: Password for the keystore. (Optional)
            
        -   **CHAIN_RPC**: RPC for Vola Chain devnet.
            
        -   **STORAGE_CAPACITY**: Amount of storage in GB to offer to the network.
            
        -   **GATEWAY_DOMAIN**: Public domain pointing to the running aggregator node.
            
        -   **GATEWAY_PORT**: Port to use with the **GATEWAY_DOMAIN** for secure (SSL) access. Default is `443`.
            
    
    Ensure that these variables are properly configured to match your environment and security requirements.
    
3.  **Verify Environment Configuration:**
    
    Run the following script to check if all required environment variables are set:
    
    ```bash
    bash env-check.sh
    
    ```
    
    If there are missing or incorrect values, update the _.env_ file accordingly.
    
4.  **Setup SSL and Start the Node:**
    
    Run the `setup.sh` script, which will:
    
    -   Verify the environment variables.
        
    -   Obtain an SSL certificate using Let's Encrypt.
        
    -   Configure an Nginx reverse proxy with SSL.
        
    -   Start the Aggregator Node using Docker Compose.
        
    
    ```bash
    bash setup.sh
    
    ```
    
    To run in detached mode, use:
    
    ```bash
    bash setup.sh --detach
    
    ```
    
5.  **Register the Node:** Before participating in aggregation, the node must be registered on the blockchain.
    
    -   Ensure the owner account has sufficient balance for registration and transaction fees.
        
    -   The domain should be publicly accessible with SSL configured.
        
    
    Register the node with:
    
    ```bash
    source .env
    docker exec -it aggregator-node /usr/local/bin/aggregator-node register --chain-rpc $CHAIN_RPC --address $ACCOUNT --gateway $GATEWAY_DOMAIN --gateway-port $GATEWAY_PORT --capacity $STORAGE_CAPACITY
    
    ```
    
    After registration, your node can start receiving upload requests.
    

## How the Code Works

The project consists of multiple scripts and configurations that work together to set up and run the Vola Aggregator Node:

-   **`setup.sh`**:
    
    -   Verifies required dependencies and environment variables.
        
    -   Obtains SSL certificates using Let's Encrypt.
        
    -   Configures an Nginx reverse proxy with SSL support.
        
    -   Starts the Aggregator Node using Docker Compose.
        
-   **`env-check.sh`**:
    
    -   Ensures all required environment variables are properly set.
        
    -   Checks for missing or incorrect values before proceeding.
        
-   **`nginx/conf.d/default.conf`**:
    
    -   Defines the Nginx configuration for handling HTTPS traffic.
        
    -   Forwards requests to the Aggregator Node running on the local machine.
        
-   **Docker Compose Setup (`docker-compose.yml`)**:
    
    -   Defines services for running the Aggregator Node inside a container.
        
    -   Ensures the correct networking setup for secure communication.
        

## How to Configure the Code

-   **Modify Environment Variables:**
    
    -   Update `.env` to set required parameters such as node address, port, and storage capacity.
        
    -   Use a valid **GATEWAY_DOMAIN** that points to your server for SSL setup.
        
-   **Customizing Nginx Configuration:**
    
    -   If needed, modify `nginx/conf.d/default.conf` to adjust proxy settings or add additional security headers.
        
    -   Restart Nginx using:
        
        ```bash
        docker restart nginx
        
        ```
        
-   **Manually Renewing SSL Certificates:**
    
    -   The setup script automatically handles SSL, but if renewal is required, run:
        
        ```bash
        docker run --rm -v $(pwd)/certbot/config:/etc/letsencrypt certbot/certbot renew
        
        ```
        
-   **Running in Detached Mode:**
    
    -   Use `bash setup.sh --detach` to run the node in the background.
        
    -   To stop the node, run:
        
        ```bash
        docker-compose down
        
        ```
        

## Additional Notes

-   The `setup.sh` script ensures Docker is installed and running.
    
-   If SSL certificate generation fails, it provides an option for manual DNS validation.
    
-   The Nginx configuration file is generated automatically in `nginx/conf.d/default.conf`.
    
-   SSL certificates are stored in `certbot/config` and automatically used by Nginx.
    
-   The Aggregator Node will be accessible securely via **https://GATEWAY_DOMAIN:$GATEWAY_PORT**.
    

This setup ensures a fully automated deployment of the Vola Aggregator Node with HTTPS support.

> **Troubleshooting**
> If you are having issue with running the script, please run the script as sudo as for some operating system may requires sudo access for docker
