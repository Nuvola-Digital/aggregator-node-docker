# Vola Aggregator Node

This repository contains scripts for easy orchestration of the Vola Aggregator Node.

## Requirement

- Docker Compose

## How to run?

- Clone the repository.
- Copy `.env.example` to `.env` and update the `.env` file.
- Run `docker-compose up -d`.

## Envs

- **LISTEN_IP**: IP address the node listens on. Default is `0.0.0.0`.
- **LISTEN_PORT**: Port the node listens on. Default is `1331`.
- **ACCOUNT**: Address of the owner account.
- **SURI**: Secret phrase for account key generation.
- **KEYSTORE_PASSWORD**: Password for the keystore.

Ensure that these variables are properly configured to match your environment and security requirements.

## Generate Keys (Optional)

If `SURI` or `ACCOUNT` is missing, the `entry.sh` script will automatically generate them and log the details.

## Logs

To view the logs:

```bash
docker logs aggregator-node
```

## Troubleshooting

1. **Missing Keys**:
   - If `SURI` or `ACCOUNT` is missing, keys will be auto-generated during startup.
2. **Failed Node Start**:

   - Check if the ports are already in use.
   - Validate the environment variables in `.env`.

3. **Container Restart**:
   - Services are configured with `restart: unless-stopped`. If a service stops, it will attempt to restart automatically.

## Volumes

Ensure the necessary volumes are set up as specified in `docker-compose.yml`.
