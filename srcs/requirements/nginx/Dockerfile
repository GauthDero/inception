# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/08 17:12:44 by gdero             #+#    #+#              #
#    Updated: 2026/01/08 17:12:45 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt update -y && apt install nginx -y && apt install openssl -y
RUN rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/sites-available/default

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/certificate.sh /certificate.sh

RUN chmod 755 /certificate.sh && chmod -R 755 /var/www/html

# transfert des droits vers nginx
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

## Utilise le script bash comme point d’entrée (entrypoint)
ENTRYPOINT ["bash", "/certificate.sh"]