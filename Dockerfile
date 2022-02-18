FROM postgres:latest

RUN apt-get update
RUN apt-get install wget -y

WORKDIR /tmp


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


RUN bash -c ' \
    declare -A SQL=( \
    [world]="(dbsamples-0.1/world/world.sql)" \
    ) && \
    declare -A URL=( \
    [world]=https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz \
    ) && \
    for DATASET in "${!SQL[@]}"; do \
    export DATASET_URL="${URL[$DATASET]}" && \
    declare -a DATASET_SQL="${SQL[$DATASET]}" && \
    if [[ $DATASETS == *"$DATASET"* ]]; then \
    echo "Populating dataset: ${DATASET}" && \
    if [[ $DATASET_URL == *.tar.gz ]]; then \
    wget -qO- $DATASET_URL | tar -C . -xzf -; \
    elif [[ $DATASET_URL == *.zip ]]; then \
    wget $DATASET_URL -O tmp.zip && \
    unzip -d . tmp.zip; \
    rm tmp.zip; \
    elif [[ $DATASET_URL == *.git ]]; then \
    git clone $DATASET_URL; \
    fi && \
    echo "CREATE DATABASE $DATASET;" >> "/docker-entrypoint-initdb.d/${DATASET}.sql" && \
    echo "\c $DATASET;" >> "/docker-entrypoint-initdb.d/${DATASET}.sql" && \
    for i in "${!DATASET_SQL[@]}"; do \
    cat "${DATASET_SQL[i]}" >> "/docker-entrypoint-initdb.d/${DATASET}.sql"; \
    done && \
    rm -rf *; \
    fi; \
    done' 

USER $PG_USER
WORKDIR $PG_HOME

