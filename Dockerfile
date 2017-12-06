ARG BASE_VERSION=9.6
FROM postgres:${BASE_VERSION}

# Install dependencies
RUN apt-get update && apt-get install -y git perl rsync

# Install omnipitr
RUN git clone https://github.com/omniti-labs/omnipitr.git /tmp/omnipitr
RUN mv /tmp/omnipitr/bin/* /usr/local/sbin
RUN mv /tmp/omnipitr/lib/OmniPITR /usr/local/lib

# Make sure it is setup correctly
RUN sanity-check.sh

# Cleanup
RUN rm -r /tmp/omnipitr

# Our configs and scripts
ADD bin/* /usr/local/sbin
ADD config/* /var/lib/postgresql/data
RUN chmod +x /usr/local/sbin/omnipitr_wal_backup.sh

# Create directories required by OmniPITR
RUN mkdir /tmp/omnipitr-archive
RUN chown postgres:postgres /tmp/omnipitr-archive
