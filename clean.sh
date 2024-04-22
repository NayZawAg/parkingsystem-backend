#!/bin/sh
cd `dirname $0` && cd .

docker-compose stop
docker-compose down --rmi all --remove-orphans
docker volume rm miyoshi-backend_bundle
docker volume rm miyoshi-backend_mssqldb
docker volume rm miyoshi-backend_redis
docker volume rm miyoshi-backend_node_modules
