#!/bin/bash

# Path to the .env file
ENV_FILE=".env"

# Check if the .env file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Define required environment variables and their descriptions
declare -A REQUIRED_VARS
REQUIRED_VARS=(
    [LISTEN_ADDR]="Interface where the Aggregator Node will listen."
    [LISTEN_PORT]="Port where the Aggregator Node will listen."
    [ACCOUNT]="SS58 Address format for the account."
    [SURI]="Secret URI for the account."
    [KEYSTORE_PASSWORD]="Password for the keystore."
    [CHAIN_RPC]="RPC endpoint for Vola Chain."
    [STORAGE_CAPACITY]="Amount of storage in GB to offer to the network."
    [NODE_LOCATION]="Geographical location where the node is running."
    [GATEWAY_DOMAIN]="Public domain pointing to the aggregator node."
    [GATEWAY_PORT]="SSL port for accessing the node."
)

# Read the .env file and export variables
while IFS='=' read -r key value; do
    if [[ -n "$key" && "$key" != "#"* ]]; then
        export "$key"="$value"
    fi
done < "$ENV_FILE"

# Check for missing variables
MISSING=()
for var in "${!REQUIRED_VARS[@]}"; do
    if [[ -z "${!var}" ]]; then
        MISSING+=("$var: ${REQUIRED_VARS[$var]}")
    fi
done

# Output results
if [[ ${#MISSING[@]} -ne 0 ]]; then
    echo "Error: Missing required environment variables:"
    for msg in "${MISSING[@]}"; do
        echo "  - $msg"
    done
    exit 1
else
    echo "All required environment variables are set."
fi