# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    mariadb.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/08 17:12:12 by gdero             #+#    #+#              #
#    Updated: 2026/01/09 13:15:33 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

echo "Starting MariaDB container"

#Secrets
MYSQL_ROOT_PWD=$(< /run/secrets/db_root_pwd)
MYSQL_USER_PWD=$(< /run/secrets/db_user_pwd)

REQUIRED_VARS=(
	MYSQL_ROOT_PWD
	MYSQL_DATABASE
	MYSQL_USER
	MYSQL_USER_PWD
)

for var in "${REQUIRED_VARS[@]}"; do
	if [ -z "${!var}" ]; then
		echo "Missing environment variable: $var"
		exit 1
	fi
done

#Start MariaDB
service mariadb start

#attente de mariadb
echo "Waiting for MariaDB..."

MAX_TRIES=20
i=0
until mysqladmin ping -h localhost --silent; do
	i=$((i + 1))
	if [ "$i" -ge "$MAX_TRIES" ]; then
		echo "MariaDB did not respond"
		exit 1
	fi
	sleep 2
done

echo "MariaDB is available"

#setup database
echo "Configuring database and users"
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}';
FLUSH PRIVILEGES;
EOF

mysql -u root -p"${MYSQL_ROOT_PWD}" <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database and user ready"

#redemarrer mariadb en fond
mysqladmin -u root -p"${MYSQL_ROOT_PWD}" shutdown
sleep 2

exec mysqld_safe

