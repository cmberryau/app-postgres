#!/usr/bin/env bash
set -e

# set up replication user in authentication file
echo "host replication $POSTGRES_REPLICATION_USER 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

# create the replication user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER "$POSTGRES_REPLICATION_USER" REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$POSTGRES_REPLICATION_PASS';
EOSQL

# create the app user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER "$APP_DATABASE_USER" WITH PASSWORD '$APP_DATABASE_PASS';
    ALTER USER "$APP_DATABASE_USER" CREATEDB;
EOSQL

# create the the app database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "$APP_DATABASE_NAME";
    GRANT ALL PRIVILEGES ON DATABASE "$APP_DATABASE_NAME" TO "$APP_DATABASE_USER";
EOSQL
