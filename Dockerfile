FROM postgres:latest

RUN apt-get update && apt-get install wget -y

WORKDIR /tmp
COPY dbfiles/ /tmp/

ARG DATASETS=world
ARG PG_USER=postgres
ARG PG_HOME=/home/$PG_USER
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB donotuse

# Enable psql history.
RUN mkdir -p $PG_HOME && \
    touch $PG_HOME/.psql_history && \
    chown -R $PG_USER:$PG_USER $PG_HOME

RUN wget -qO- https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz | tar -C . -xzf -; 

RUN echo "CREATE DATABASE world;" >> "/docker-entrypoint-initdb.d/world.sql" 
RUN bash -c 'echo "\c world;" >> "/docker-entrypoint-initdb.d/world.sql"'
RUN cat dbsamples-0.1/world/world.sql >> "/docker-entrypoint-initdb.d/world.sql";
RUN cat extend_database.sql >> "/docker-entrypoint-initdb.d/world.sql";
RUN cat battle.sql >> "/docker-entrypoint-initdb.d/world.sql";

USER $PG_USER
WORKDIR $PG_HOME

