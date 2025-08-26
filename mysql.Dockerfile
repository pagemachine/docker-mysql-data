ARG MYSQL_IMAGE_VERSION
FROM mysql:${MYSQL_IMAGE_VERSION} as base

ARG MYSQL_DATABASE
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ARG MYSQL_USER
ENV MYSQL_USER=${MYSQL_USER}
ARG MYSQL_PASSWORD
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}
ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

FROM base as init

COPY --from=data * /docker-entrypoint-initdb.d

RUN mkdir --parents /var/lib/mysql-data \
    && chown mysql:mysql /var/lib/mysql-data

RUN sed --in-place 's/exec "$@"//' /usr/local/bin/docker-entrypoint.sh

RUN docker-entrypoint.sh --datadir /var/lib/mysql-data

FROM base

COPY \
    --from=init \
    --chown=mysql:mysql \
    /var/lib/mysql-data \
    /var/lib/mysql
