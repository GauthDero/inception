# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gdero <gdero.s19.be>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/19 19:01:03 by gdero             #+#    #+#              #
#    Updated: 2026/01/10 12:06:27 by gdero            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


SECRETS_DIR := secrets

DB_ROOT_PWD := $(SECRETS_DIR)/db_root_password.txt
DB_USER_PWD := $(SECRETS_DIR)/db_user_password.txt
WP_ADMIN_PWD := $(SECRETS_DIR)/wp_admin_password.txt
WP_USER_PWD := $(SECRETS_DIR)/wp_user_password.txt

SECRETS_FILES := $(DB_ROOT_PWD) $(DB_USER_PWD) $(WP_ADMIN_PWD) $(WP_USER_PWD)

.PHONY: all
all: secrets docker-up

#Secret folder

$(SECRETS_DIR)/.dir:
	@echo "[INFO] Creating secrets directory"
	@mkdir -p $(SECRETS_DIR)
	@chmod 700 $(SECRETS_DIR)
	@touch $@

#Secret files

$(SECRETS_FILES): $(SECRETS_DIR)/.dir
	@if [ ! -s $@ ]; then \
		echo "[INFO] Generating $@"; \
		(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 10; echo) > $@; \
		chmod 600 $@; \
	else \
		echo "[INFO] $@ already exists"; \
	fi

.PHONY: secrets
secrets: $(SECRETS_FILES)

.PHONY: docker-up
docker-up:
	@echo "[INFO] Starting docker compose"
	cd srcs && docker compose up --build

.PHONY: compose
compose:
	@echo "[INFO] Recompose containers"
	cd srcs && docker compose up
	
.PHONY: clean
clean:
	@echo "[INFO] Stopping docker compose"
	cd srcs && docker compose down

.PHONY: clean-secrets
clean-secrets:
	@echo "[INFO] Removing secrets directory"
	rm -rf $(SECRETS_DIR)

.PHONY: fclean
fclean: clean clean-secrets
	docker system prune -f --volumes
	sudo chmod -R 777 /home/gdero/data/mysql;
	sudo chmod -R 777 /home/gdero/data/wordpress;
	rm -rf /home/gdero/data/mysql/* data/mysql/.[!.]*;
	rm -rf /home/gdero/data/wordpress/* data/wordpress/.[!.]*;
	@echo "[INFO] Full cleanup done"

.PHONY: re
re: fclean all

