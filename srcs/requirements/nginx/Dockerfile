FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx curl

# Webルートディレクトリを作成し、Nginxの実行ユーザーに所有権を与える
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY default /etc/nginx/sites-enabled/default

ENTRYPOINT ["nginx", "-g", "daemon off;"]
