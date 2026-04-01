# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    wordpress.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/08 17:12:48 by gdero             #+#    #+#              #
#    Updated: 2026/01/12 11:14:00 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

echo "Starting WordPress container"

#Secrets
MYSQL_USER_PWD=$(< /run/secrets/db_user_pwd)
WP_ADMIN_PWD=$(< /run/secrets/wp_admin_pwd)
WP_USER_PWD=$(< /run/secrets/wp_user_pwd)

REQUIRED_VARS=(
	MYSQL_DATABASE
	MYSQL_USER
	MYSQL_USER_PWD
	DOMAIN_NAME
	WP_ADMIN
	WP_ADMIN_PWD
	WP_ADMIN_EMAIL
	WP_USER
	WP_USER_EMAIL
	WP_USER_PWD
)

for var in "${REQUIRED_VARS[@]}"; do
	if [ -z "${!var}" ]; then
		echo "Missing environment variable: $var"
		exit 1
	fi
done

#attente de mariadb
echo "Waiting for MariaDB..."

MAX_TRIES=20
i=0
until mysqladmin ping -h mariadb -u "$MYSQL_USER" \
	-p"$MYSQL_USER_PWD" --silent
do
	i=$((i + 1))
	if [ "$i" -ge "$MAX_TRIES" ]; then
		echo "Unable to connect to MariaDB"
		exit 1
	fi
	sleep 2
done

echo "MariaDB is available"

#installation wordpress
WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Downloading WordPress"
	wp core download --version=6.0 --locale=fr_FR \
		--path="$WP_PATH" --allow-root

	echo "Creating wp-config.php"
	wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_USER_PWD" --dbhost="mariadb:3306" \
		--path="$WP_PATH" --allow-root

	echo "Installing WordPress"
	wp core install --url="$DOMAIN_NAME" --title="gderoception" \
		--admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PWD" \
		--admin_email="$WP_ADMIN_EMAIL" --path="$WP_PATH" \
		--allow-root

	echo "Creating WordPress user: $WP_USER"
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PWD" --role=author \
		--path="$WP_PATH" --allow-root
fi

#transfert des droits a nginx
mkdir -p /run/php
chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

#php
echo "Starting PHP-FPM 8.2"
exec php-fpm8.2 -F

