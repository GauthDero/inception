# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/08 17:12:52 by gdero             #+#    #+#              #
#    Updated: 2026/01/08 17:12:53 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y wget php8.2-fpm php8.2-mysql mariadb-client

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

#outils terminal wordpress + root wp
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
    && chmod 755 /usr/local/bin/wp && mkdir -p /var/www/html

COPY tools/wordpress.sh /wordpress.sh

RUN chmod 755 /wordpress.sh

EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["bash", "/wordpress.sh"]


