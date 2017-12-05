ARG BASE_VERSION=9.6
FROM postgres:${BASE_VERSION}

RUN apt-get update && apt-get install -y git perl rsync
RUN git clone https://github.com/omniti-labs/omnipitr.git /tmp/omnipitr
RUN mv /tmp/omnipitr/bin/* /usr/local/sbin
RUN mv /tmp/omnipitr/lib/OmniPITR /usr/local/lib
RUN sanity-check.sh
RUN rm -r /tmp/omnipitr
ADD bin/* /usr/local/sbin
ADD config/* /var/lib/postgresql/data
RUN chmod +x /usr/local/sbin/omnipitr_wal_backup.sh
