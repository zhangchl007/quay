#!/bin/bash
echo "SELECT * FROM pg_available_extensions" | /opt/rh/rh-postgresql96/root/usr/bin/psql
echo "CREATE EXTENSION IF NOT EXISTS pg_trgm;" | /opt/rh/rh-postgresql96/root/usr/bin/psql -d quaydb
echo "SELECT * FROM pg_extension" | /opt/rh/rh-postgresql96/root/usr/bin/psql
echo "ALTER USER quayuser WITH SUPERUSER;" | /opt/rh/rh-postgresql96/root/usr/bin/psql
echo "CREATE DATABASE clairtest WITH OWNER = postgres ENCODING = 'UTF8';"| /opt/rh/rh-postgresql96/root/usr/bin/psql
echo "ALTER ROLE postgres WITH PASSWORD 'password';"| /opt/rh/rh-postgresql96/root/usr/bin/psql
