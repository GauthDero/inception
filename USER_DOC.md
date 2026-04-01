# Provided Services

This project provides a secure WordPress website using the following services:
- NGINX: handles HTTPS connections and acts as the entry point
- WordPress: content management system accessible via a web interface
- MariaDB: database used by WordPress


# Starting and Stopping the Project

At the project root directory :

- To start the project:
make

- To stop the containers:
make clean

- To stop the containers and remove all data:
make fclean


# Website and Administration Access

The website is accessible at:
https://gdero.42.fr

The WordPress administration panel is accessible at:
https://gdero.42.fr/wp-admin


# Credentials Management

Credentials are managed using environment variables and Docker secrets.
Passwords are not hardcoded inside the containers.
Secrets are stored in the `secrets/` directory.

# Checking Service Status

To check that the services are running:
docker ps

To view logs:
docker compose logs
docker compose logs <service>
