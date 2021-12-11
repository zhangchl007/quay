#!/bin/bash
echo "SELECT * FROM pg_available_extensions" | /usr/bin/psql
echo "CREATE EXTENSION IF NOT EXISTS pg_trgm;" | /usr/bin/psql -d quaydb
echo "SELECT * FROM pg_extension" | /usr/bin/psql
echo "ALTER USER quayuser WITH SUPERUSER;" | /usr/bin/psql
echo "CREATE DATABASE clairtest WITH OWNER = postgres ENCODING = 'UTF8';"| /usr/bin/psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p  "$POSTGRES_PORT_5432_TCP_PORT" -U postgres
#echo "CREATE DATABASE clairtest WITH OWNER = postgres ENCODING = 'UTF8';"| /usr/bin/psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p  "$POSTGRES_PORT_5432_TCP_PORT" -U postgres
echo "ALTER ROLE postgres WITH PASSWORD 'password';"| /usr/bin/psql
