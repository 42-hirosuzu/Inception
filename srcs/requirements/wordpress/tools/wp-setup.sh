#!/bin/bash
set -e

cd /var/www/html

# 環境変数からデータベースの設定を取得
DB_NAME="${WORDPRESS_DB_NAME:-wordpress}"
DB_USER="${WORDPRESS_DB_USER:-wpuser}"
# *_FILE が指定されていればSecretsから読み取り
if [[ -n "${WORDPRESS_DB_PASSWORD_FILE:-}" && -f "${WORDPRESS_DB_PASSWORD_FILE}" ]]; then
  DB_PASS="$(cat "${WORDPRESS_DB_PASSWORD_FILE}")"
else
  DB_PASS="${WORDPRESS_DB_PASSWORD:-password}"
fi
DB_HOST="${WORDPRESS_DB_HOST:-db}"
host_only="${DB_HOST%%:*}"
until mysqladmin ping -h"${host_only}" --silent; do
  echo "waiting for MariaDB..."
  sleep 2
done
until mysql -h"${host_only}" -u"${DB_USER}" -p"${DB_PASS}" -e 'SELECT 1' >/dev/null 2>&1; do
  echo "waiting for grants for ${DB_USER}..."
  sleep 2
done

# 既に展開済みならスキップ
if [ ! -f wp-cli.phar ]; then
   curl -sS -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
   chmod +x wp-cli.phar
fi
# 本体は無ければDL（既に index.php があればスキップ）
if [ ! -f index.php ]; then
  ./wp-cli.phar core download --force --allow-root
fi
# wp-config.php が無ければ生成
if [ ! -f wp-config.php ]; then
  ./wp-cli.phar config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --skip-check --force \
    --allow-root
fi
# 未インストールなら install
ADMIN_PASS="$( [[ -n "${WORDPRESS_ADMIN_PASSWORD_FILE:-}" && -f "${WORDPRESS_ADMIN_PASSWORD_FILE}" ]] && cat "${WORDPRESS_ADMIN_PASSWORD_FILE}" || echo "${WORDPRESS_ADMIN_PASSWORD:-admin}" )"
USER2_PASS="$( [[ -n "${WORDPRESS_USER2_PASSWORD_FILE:-}" && -f "${WORDPRESS_USER2_PASSWORD_FILE}" ]] && cat "${WORDPRESS_USER2_PASSWORD_FILE}" || echo "${WORDPRESS_USER2_PASSWORD:-changeme}" )"

# 禁止名チェック（admin/administrator を含まない）
if [[ "${WORDPRESS_ADMIN_USER:-admin}" =~ [Aa]dmin|[Aa]dministrator ]]; then
  echo "ERROR: WORDPRESS_ADMIN_USER に admin/administrator 系は使用不可"; exit 1
fi

ADMIN_PASS="$( [[ -n "${WORDPRESS_ADMIN_PASSWORD_FILE:-}" && -f "${WORDPRESS_ADMIN_PASSWORD_FILE}" ]] && cat "${WORDPRESS_ADMIN_PASSWORD_FILE}" || echo "${WORDPRESS_ADMIN_PASSWORD:-admin}" )"
USER2_PASS="$( [[ -n "${WORDPRESS_USER2_PASSWORD_FILE:-}" && -f "${WORDPRESS_USER2_PASSWORD_FILE}" ]] && cat "${WORDPRESS_USER2_PASSWORD_FILE}" || echo "${WORDPRESS_USER2_PASSWORD:-changeme}" )"
if ! ./wp-cli.phar core is-installed --allow-root; then
  ./wp-cli.phar core install \
    --url="${WORDPRESS_URL:-http://localhost}" \
    --title="${WORDPRESS_TITLE:-inception}" \
    --admin_user="${WORDPRESS_ADMIN_USER:-siteowner}" \
    --admin_password="${ADMIN_PASS}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
    --skip-email --allow-root
fi

# 2人目ユーザ（存在しなければ作成）
./wp-cli.phar user get "${WORDPRESS_USER2:-writer1}" --field=ID --allow-root >/dev/null 2>&1 || \
  ./wp-cli.phar user create "${WORDPRESS_USER2:-writer1}" "${WORDPRESS_USER2_EMAIL:-writer1@example.com}" \
    --role=author --user_pass="${USER2_PASS}" --allow-root
# if ! ./wp-cli.phar user get "${WORDPRESS_USER2:-writer1}" --field=ID --allow-root >/dev/null 2>&1; then
#   ./wp-cli.phar user create "${WORDPRESS_USER2:-writer1}" "${WORDPRESS_USER2_EMAIL:-writer1@example.com}" \
#     --role=author --user_pass="${USER2_PASS}" --allow-root
# fi

# 最後に FPM を前面起動
exec php-fpm7.4 -F

