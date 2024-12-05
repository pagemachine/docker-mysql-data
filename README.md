# Docker MySQL image with data

This repository provides a `Dockerfile` to build [MySQL](https://hub.docker.com/_/mysql)
Docker images with data.

## Usage

Adjust your Docker Compose MySQL service by adding a `build` section and changing
the `image`.

Before:

```yaml
services:
  mysql:
    image: mysql:8.1.0
    environment:
      MYSQL_DATABASE: database_name
      MYSQL_USER: user_name
      MYSQL_PASSWORD: user_password
      MYSQL_ROOT_PASSWORD: root_password
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 10
```

After:

```yaml
services:
  mysql:
    build:
      context: https://github.com/pagemachine/docker-mysql-data.git#0.0.1
      additional_contexts:
        data: ./data
      args:
        MYSQL_IMAGE_VERSION: 8.1.0
        MYSQL_DATABASE: database_name
        MYSQL_USER: user_name
        MYSQL_PASSWORD: user_password
        MYSQL_ROOT_PASSWORD: root_password
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 10
    image: registry.example/my-project/mysql:latest
```

- `build.context` points to the URL of this GitHub repository, the fragment refers
  to a release, `0.0.1` in this case, try to always use the
  [latest release](https://github.com/pagemachine/docker-mysql-data/releases).
- `build.additional_contexts.data` must be defined and point to a local directory
  with `*.sql`, `.sql.gz` or `.sh` files to use for populating the database on build.
- `build.args.MYSQL_IMAGE_VERSION` must be a valid tag of the `mysql` Docker image.
- `build.args.MYSQL_DATABASE` is the name of the database to create.
- `build.args.MYSQL_USER` is the username to set up for the database.
- `build.args.MYSQL_PASSWORD` is the password to set for the database user.
- `build.args.MYSQL_ROOT_PASSWORD` is the password of the `root` user.
- `image` should set a persistent image name/tag and a registry to push this image
  to, this way other users will automatically pull the prebuilt image instead of
  building it again.

## MariaDB

Images using MariaDB instead of MySQL can be built by setting the `MYSQL_IMAGE_NAME`
build argument.

Before:

```yaml
services:
  mariadb:
    image: mariadb:10.5.27
    environment:
      MARIADB_DATABASE: database_name
      MARIADB_USER: user_name
      MARIADB_PASSWORD: user_password
      MARIADB_ROOT_PASSWORD: root_password
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10
```

After:

```yaml
services:
  mariadb:
    build:
      context: https://github.com/pagemachine/docker-mysql-data.git#0.0.1
      additional_contexts:
        data: ./data
      args:
        MYSQL_IMAGE_NAME: mariadb
        MYSQL_IMAGE_VERSION: 10.5.27
        MYSQL_DATABASE: database_name
        MYSQL_USER: user_name
        MYSQL_PASSWORD: user_password
        MYSQL_ROOT_PASSWORD: root_password
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10
    image: registry.example/my-project/mariadb:latest
```

- `build.args.MYSQL_IMAGE_VERSION` must be a valid tag of the `mariadb` Docker image.
- `build.args.MYSQL_DATABASE` is the name of the database to create.
- `build.args.MYSQL_USER` is the username to set up for the database.
- `build.args.MYSQL_PASSWORD` is the password to set for the database user.
- `build.args.MYSQL_ROOT_PASSWORD` is the password of the `root` user.
