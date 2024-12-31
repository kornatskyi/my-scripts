#!/bin/bash

LOCKFILE="/tmp/rsync_lock"
LASTRUN="/tmp/rsync_lastrun"

GDRIVE_FOLDER="/run/user/1000/gvfs/google-drive:host=gmail.com,user=lifehere23/0AAKMDCWzXOVaUk9PVA/1ZS7UFXCw99MbVwYB66E9JIUYYzOO7lS9"


# Exit if another instance is running
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    exit
fi

# Make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Check if it's been at least 5 seconds since last run
if [ -f ${LASTRUN} ]; then
    last_run=$(cat ${LASTRUN})
    now=$(date +%s)
    if [ $((now - last_run)) -lt 5 ]; then
        exit
    fi
fi

# Run rsync
rsync -rlptDv --modify-window=1 --no-perms --no-owner --no-group ~/temporary/ "$GDRIVE_FOLDER/"

# Update last run time
date +%s > ${LASTRUN}

# Remove lockfile
rm -f ${LOCKFILE}