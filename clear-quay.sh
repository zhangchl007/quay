#!/bin/bash
docker-compose  -f docker-compose.quay-pgsql.yml stop
docker-compose  -f docker-compose.quay-pgsql.yml rm -f
rm -rf /quay/*
rm -rf /var/lib/mysql
rm -rf /var/lib/redis
rm -rf /var/lib/pgsql/data
docker container prune
docker volume prune

