#!/bin/sh
set -eu

DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASS="$(cat /run/secrets/db_password)"
ROOT_PASS="$(cat /run/secrets/db_root_password)"

if [ ! -d /var/lib/mysql/mysql ]; then
  mariadb-install-db --user=root --ldata=/var/lib/mysql >/dev/null
  # 初回だけ init-file で実行（通常モードなので GRANT 可）
  cat >/tmp/init.sql <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL
  exec mysqld --user=root --init-file=/tmp/init.sql --console
fi

exec mysqld --user=root --console
