# srcsディレクトリにあるdocker-compose.ymlを対象にするための変数
COMPOSE_FILE = srcs/docker-compose.yml
DB = db
WP = wordpress
NX = nginx
LOGIN = hirosuzu

# デフォルトのターゲット
all: build up

# Dockerイメージをビルドする
build:
	@docker-compose -f $(COMPOSE_FILE) build

# コンテナをバックグラウンドで起動する
up:
	@docker-compose -f $(COMPOSE_FILE) up -d

# コンテナを停止する
down:
	@docker-compose -f $(COMPOSE_FILE) down

# コンテナを停止し、関連するボリュームも削除する
clean:
	@docker-compose -f $(COMPOSE_FILE) down --volumes

# コンテナとイメージを全て削除し、再ビルドして起動する
re: clean
	@docker-compose -f $(COMPOSE_FILE) up --build -d

# ログを表示する
logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

logs-wp:
	@docker-compose -f $(COMPOSE_FILE) logs -f $(WP)
logs-nginx:
	@docker-compose -f $(COMPOSE_FILE) logs -f $(NX)
logs-db:
	@docker-compose -f $(COMPOSE_FILE) logs -f $(DB)

ps:
	@docker-compose -f $(COMPOSE_FILE) ps

init:
	@bash scripts/bootstrap_secrets.sh

curl:
	@curl -vk https://127.0.0.1/ || true

users:
	@docker exec -it wordpress bash -lc "cd /var/www/html && ./wp-cli.phar user list --allow-root"

ssl:
	@docker exec -it nginx sh -lc 'openssl x509 -in /run/secrets/tls_cert -noout -subject -issuer -dates'

.PHONY: all build up run down clean re logs logs-wp logs-nginx logs-db ps
