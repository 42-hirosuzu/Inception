#!/usr/bin/env bash
set -euo pipefail

LOGIN="hirosuzu"
SECRETS_DIR="secrets"
DATA_BASE="/home/${LOGIN}/data"

mkdir -p "${SECRETS_DIR}"
chmod 700 "${SECRETS_DIR}"

make_secret () { # make_secret <path>
  if [[ ! -f "$1" ]]; then
    # URLやシェルで扱いやすい文字のみ（32バイト=64hex）
    openssl rand -hex 32 > "$1"
    chmod 600 "$1"
    echo "created: $1"
  else
    echo "exists : $1 (skip)"
  fi
}

make_secret "${SECRETS_DIR}/db_root_password.txt"
make_secret "${SECRETS_DIR}/db_password.txt"
make_secret "${SECRETS_DIR}/wp_admin_password.txt"
make_secret "${SECRETS_DIR}/wp_user2_password.txt"

# TLS証明書（自己署名）— 既存ならスキップ
if [[ ! -f "${SECRETS_DIR}/tls.crt" || ! -f "${SECRETS_DIR}/tls.key" ]]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "${SECRETS_DIR}/tls.key" -out "${SECRETS_DIR}/tls.crt" \
    -subj "/CN=${LOGIN}.42.fr"
  chmod 600 "${SECRETS_DIR}/tls.key" "${SECRETS_DIR}/tls.crt"
  echo "created: tls.key/tls.crt"
else
  echo "exists : tls.key/tls.crt (skip)"
fi

# ホスト永続ディレクトリ（要件の場所）
mkdir -p "${DATA_BASE}/db" "${DATA_BASE}/wp"

# .gitignore 追記（重複回避）
GI=".gitignore"
add_ignore () { grep -qxF "$1" "$GI" 2>/dev/null || echo "$1" >> "$GI"; }
add_ignore "secrets/"
add_ignore "!secrets/README.md"
add_ignore "*.crt"
add_ignore "*.key"

echo "Done."

