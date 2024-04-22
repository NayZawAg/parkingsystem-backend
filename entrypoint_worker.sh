#!/bin/bash
set -e

# SSHサーバーがポート2222で立ち上がる
service ssh start

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# webpackのキャッシュを削除
rm -Rf public/packs/

# 起動時にマイグレーションを実行する
if [[ $RAILS_ENV = 'production' ]]; then
  bundle exec rake assets:clobber
  bundle exec rake assets:precompile
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"