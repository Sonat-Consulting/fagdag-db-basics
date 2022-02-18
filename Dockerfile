FROM postgres:latest

RUN apt-get update
RUN apt-get install wget -y

WORKDIR /tmp
RUN wget -qO- https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz | tar -C . -xzf -;
RUN echo "CREATE DATABASE world;" >> "/docker-entrypoint-initdb.d/world.sql"
RUN echo "\c world;" >> "/docker-entrypoint-initdb.d/world.sql"
RUN cat /tmp/dbsamples-0.1/world/world.sql >> "/docker-entrypoint-initdb.d/world.sql"

COPY dbfiles/ /srv/dbfiles
