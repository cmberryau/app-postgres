FROM postgres:11.5-alpine

# copy the init script
COPY init.sh /docker-entrypoint-initdb.d