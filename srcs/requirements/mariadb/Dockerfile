FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld /var/lib/mysql

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# COPY init.sql /etc/mysql/init.sql
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

ENTRYPOINT ["/usr/local/bin/run.sh"]

# RUN /run/mysqld

# CMD ["mysqld"]