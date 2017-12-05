#!/bin/bash

SUCCESSFILE=/tmp/omnipitr_wal_backup_success
FAILUREFILE=/tmp/omnipitr_wal_backup_failure

# Pull arguments
if [[ -z $1 ]]; then
    echo "No input given! Please supply WAL segment as first argument"
    exit 2
else
    WAL_SEGMENT="$1"
fi

function log_and_exit() {
    logger "[omnipitr_wal_backup] Backup successful for $WAL_SEGMENT"
    touch $SUCCESSFILE
    exit 0
}

# Start the backup of this segment
/usr/local/sbin/omnipitr-archive \
    -l /dev/stdout \
    -D $PGDATA\
    -dl gzip=$OMNIPITR_WAL_BACKUP_DIR \
    $WAL_SEGMENT

# Check for errors
if [[ $? != 0 ]]; then
    # Log fail to syslog
    logger "[omnipitr_wal_backup] Backup failed for $WAL_SEGMENT"
    # Log fail to stdout
    echo "[omnipitr_wal_backup] Backup failed for $WAL_SEGMENT"
    touch $FAILUREFILE
    exit 1
fi

# Log to stdout
echo "[omnipitr_wal_backup] Backup successful for $WAL_SEGMENT"

if [ ! -f $SUCCESSFILE ]; then
    log_and_exit
fi

# Don't log to syslog more than once every hour
if [[ $(find $SUCCESSFILE -cmin +$(date +%M) 2>/dev/null ) ]]; then
    log_and_exit
fi

# Log success if last backup failed
if [[ -f $FAILUREFILE ]]; then
    rm $FAILUREFILE
    log_and_exit
fi
