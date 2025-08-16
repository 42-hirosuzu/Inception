FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php7.4-fpm php-mysql vim curl mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh

RUN chmod +x /usr/local/bin/wp-setup.sh

# ENTRYPOINT ["php-fpm7.4", "-F"]
ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]
