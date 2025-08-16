FROM debian:bullseye

# NginxとPHP-FPMの両方をインストールする
RUN apt-get update && apt-get install -y nginx php7.4-fpm

# 設定ファイルをコンテナ内にコピーする
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY index.php /var/www/html/

# PHP-FPMがソケットファイルを作るためのディレクトリを作成
RUN mkdir -p /run/php

# コンテナ起動時に両方のサービスを開始するスクリプトを実行
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Supervisorをインストール
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
