# Architecture

The infrastructure is composed of three containers:
- nginx
- wordpress
- mariadb

Each container runs a single main process and is built from its own Dockerfile.

# Docker Compose Configuration

The docker-compose file defines:
- Services
- A dedicated Docker network
- Named Docker volumes
- Environment variables and secrets

All containers communicate through the Docker network using service names as hostnames.


# NGINX

- Acts as the single entry point
- Listens only on port 443
- Uses a self-signed TLS certificate (TLSv1.2 / TLSv1.3)

# WordPress

- Runs PHP-FPM
- Uses a persistent volume for WordPress files
- Provides one administrator user and one standard user

NGINX communicates with WordPress on port 9000.


# MariaDB

- Stores WordPress data
- Uses a persistent volume for database files
- A dedicated database and user are created for WordPress

# Environment Setup

Prerequisites:
- Linux virtual machine
- Docker
- Docker Compose
- Make

Configuration files are located in the `srcs/` directory.
Environment variables are defined in the `.env` file.
Sensitive information such as passwords is stored using Docker secrets in the `secrets/` directory (will be created at launch).

# Build and Launch

To build images and start the infrastructure:
make

This command uses Docker Compose to build all images, create the network, the volumes and the secret credentials, and start all containers.

# Container and Volume Management

List running containers:
docker ps

Stop containers:
docker compose down

Remove containers and volumes:
docker compose down --volumes

Access a container shell:
docker exec -it <service> bash

# Data Persistence

Project data is stored using Docker volumes.
Volumes are mapped on the host system under:
 /home/gdero/data/

Data persists across container restarts and virtual machine reboot.
Removing volumes resets all stored data.
