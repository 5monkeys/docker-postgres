# docker-postgres

[![docker hub badge](https://img.shields.io/docker/pulls/5monkeys/postgres.svg)](https://hub.docker.com/r/5monkeys/postgres/)

Docker image for PostgreSQL with support for [OmniPITR](https://github.com/omniti-labs/omnipitr).
This image is based on the official PostgreSQL [image](https://hub.docker.com/_/postgres/).

## Usage

```
docker run \
    --name some-postgres \
    -e OMNIPITR_WAL_BACKUP_DIR=/opt/backup \
    -v /opt/backup:/opt/backup \
    5monkeys/postgres
```

Refer to the official postgres image [documentation](https://hub.docker.com/_/postgres/)
for more details.

## Environment variables

### `OMNIPITR_WAL_BACKUP_DIR`

**Default**: `/backup`

The path where OmniPITR will store the WAL files.
