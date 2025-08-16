#!/bin/bash

# 出力ファイル名を定義
output_file="merged.txt"

# 'tree'コマンドの存在を確認し、なければインストールを促す
if ! command -v tree &> /dev/null
then
    echo "'tree' コマンドが見つかりませんでした。先にインストールしてください。"
    echo "Debian/Ubuntuの場合: sudo apt-get update && sudo apt-get install tree"
    exit 1
fi

# 既に出力ファイルが存在する場合は削除して、まっさらな状態から始める
rm -f "$output_file"

# --- ここからが変更点 ---
# 1. ディレクトリ構成を出力ファイルに書き込む
echo "■■■ Directory Structure ■■■" >> "$output_file"
tree -I html >> "$output_file"
echo "" >> "$output_file"
echo "----" >> "$output_file"
echo "" >> "$output_file"
# --- ここまでが変更点 ---

# 2. 各ファイルの中身を書き込む
echo "■■■ File Contents ■■■" >> "$output_file"

# カレントディレクトリ以下のすべてのファイルを検索し、ループ処理を行う
# ただし、出力ファイル自身とこのスクリプト自身は除外する
find . -type f \
  -not -name "$output_file" \
  -not -name "$(basename "$0")" \
  -not -path "./srcs/requirements/wordpress/html/*" \
| while read -r filepath; do

    # ディレクトリ名を取得
    dir=$(dirname "$filepath")
    # ファイル名を取得
    filename=$(basename "$filepath")

    # 指定されたフォーマットで出力ファイルに追記する
    {
        echo ""
        echo "Directory: $dir"
        echo "File:      $filename"
        echo "---------------------------------"
        cat "$filepath"
        echo ""
        echo "----"
    } >> "$output_file"
done

echo "ディレクトリ構成とすべてのファイルが $output_file にまとめられました。"