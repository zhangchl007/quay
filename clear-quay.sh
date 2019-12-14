#!/bin/bash
docker-compose  -f docker-compose.quay.yml stop
docker-compose  -f docker-compose.quay.yml rm -f
rm -rf /quay/*
rm -rf /var/lib/mysql
rm -rf /var/lib/redis
docker container prune
docker volume prune

