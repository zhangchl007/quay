#!/bin/bash
docker stop config && docker rm config
docker-compose  -f docker-compose.config-mysql.yml stop
docker-compose  -f docker-compose.config-pgsql.yml stop
