#!/bin/sh
cd `dirname $0` && cd .

docker-compose build
docker-compose run --rm db bash -c 'pass="password" /opt/mssql-tools/bin/sqlcmd -S mssql -U SA -P 'P@ssw0rd2022' -i /sqls/init.sql -W'
docker-compose run --rm backend bash -c 'bundle install && bin/yarn && bin/rails db:migrate:reset db:seed'
# assets precompile
docker-compose run --rm backend bash -c 'bundle exec rake assets:clobber && bundle exec rake assets:precompile'
# up
docker-compose up -d
