# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    certificate.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/08 17:12:37 by gdero             #+#    #+#              #
#    Updated: 2026/01/09 13:14:59 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

echo "Starting NGINX container"

if [ -z "$DOMAIN_NAME" ]; then
	echo "DOMAIN_NAME is not set"
	exit 1
fi

#setup SSL
SSL_DIR="/etc/nginx/ssl"
CRT="$SSL_DIR/nginx.crt"
KEY="$SSL_DIR/nginx.key"

mkdir -p "$SSL_DIR"

if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
	echo "Generating self-signed SSL certificate"
	openssl req -x509 -nodes -newkey rsa:2048 \
		-keyout "$KEY" -out "$CRT" -sha256 \
		-subj "/CN=$DOMAIN_NAME"
	echo "SSL certificate created"
else
	echo "SSL certificate already exists"
fi

#Start NGINX
echo "Starting NGINX"
exec nginx -g "daemon off;"
