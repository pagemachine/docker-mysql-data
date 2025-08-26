ARG MARIADB_IMAGE_VERSION
FROM mariadb:${MARIADB_IMAGE_VERSION} as base

ARG MARIADB_DATABASE
ENV MARIADB_DATABASE=${MARIADB_DATABASE}
ARG MARIADB_USER
ENV MARIADB_USER=${MARIADB_USER}
ARG MARIADB_PASSWORD
ENV MARIADB_PASSWORD=${MARIADB_PASSWORD}
ARG MARIADB_ROOT_PASSWORD
ENV MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}

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
