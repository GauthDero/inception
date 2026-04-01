*This project has been created as part of the 42 curriculum by gdero*

# Description

This project consists in setting up a small infrastructure composed of different services using Docker and Docker Compose.
The goal is to deploy a secure WordPress website using containerization technologies.

This project is to compile on a virtual machine, as it is necessary to modify the hosts file situated at etc/ ; change "localhost" by gdero.42.fr

The infrastructure is composed of three services :
- NGINX as a reverse proxy serving HTTPS only
- Wordpress running with PHP-FPM
- MariaDB as the database

Each service runs in its own container.
Services communicate through a dedicated Docker network and use Docker volumes to ensure data persistence.

The website is accessible only via HTTPS at :
https://gdero.42.fr

The first time we access the site, Firefox will send a warming. It's normal, as the SSL certificate we generate is self-signed.

# Instructions

From the projet root directory, type :

*make*
This will create the "secrets" repository with randomly generated passwords for admin mysql, user mysql, admin wordpress and user wordpress.
After that, the project will be compiled with docker (estimated time : ~2 min 30 on the school computers).
Wordpress will be installed and configured.
The website at https://gdero.42.fr will then be accessible.
The wordpress admin page is accessible at https://gdero.42.fr/wp-admin if you type the login situated in the .env file (/srcs/.env) and the password (/srcs/secrets/db_admin_password.txt)

*make clean*
This will stop the containers. The volumes won't be removed (persistance)

*make compose*
This will launch the containers again after a make clean

*make clean-secrets*
This will delete the secrets directory (/!\ Hazardous /!\)

*make fclean*
This will stop the containers, remove the secrets directory and the volumes (full delete).

# Resources

Docker Docs :
https://docs.docker.com
This website has many tutorials about the use of Docker

AI (ChatGPT) was used for debugging .sh scripts, synthetise informations about the use of Docker and give some leads about the writing of the readme files.

# Project description

## Project structure

The project follows a structured directory layout:
- Each service has its own Dockerfile
- Configuration files are separated by service
- Persistent data is stored using Docker volumes mapped to `/home/gdero/data`

## Virtual Machines vs Docker

Virtual Machines emulate a full operating system and are resource-intensive.
Docker containers are lightweight, faster to start, and consume fewer resources. Also, it provides better portability and easier deployment.

## Secrets vs Environment Variables

Environment variables are used to configure applications and are suitable for non-sensitive data.
Docker secrets are designed to store sensitive information such as passwords securely.
In this project, environment variables are used for configuration, while secrets are used for credentials.

## Docker Network vs Host Network

The host network exposes containers directly to the host network, reducing isolation and security.
Docker networks provide an isolated virtual network where containers can communicate securely using service names.
This project uses a dedicated Docker network to allow communication between services while maintaining isolation.

## Docker Volumes vs Bind Mounts

Bind mounts rely on specific host paths and are less portable.
Docker volumes are managed by Docker and provide better portability and reliability.
This project uses Docker volumes to ensure data persistence across container restarts and virtual machine reboot.

## Some considerations 

- On installation of the mariadb service, it's possible to get two errors ('cannot find var/run/mysqld/mysqld.sock' and 'acces denied to localhost'). This happens if the service is not ready yet, and will resolve over time. The infrastructure and functionning will not be impacted.

- On installation of the Wordpress service, this error will occur :
'sh: 1: /usr/sbin/sendmail: not found'. This could be avoided if we add 'apt-get install sendmail' in the Dockerfile of the Wordpress service, but will CONSIDERABLY lengthen the installation time. As sendmail is not usefull for this project (automated mail services), i chose not to include it. It does not impact the functionning of the infrastructure.

- As Firefox will automatically redirect http requests to https, to check if http (and thus, port 80) is effectively blocked, we can type 'curl -I http://gdero.42.fr' on the terminal