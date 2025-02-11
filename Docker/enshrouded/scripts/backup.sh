#!/bin/bash

# CMD
CMD_CP="/usr/bin/cp"
CMD_MKDIR="/usr/bin/mkdirp"

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d_%H:%M:%S"
}


function create_backup() {
  echo "[$(timestamp)] -- BACKUP: Start Backup"
  echo "[$(timestamp)] -- BACKUP: -> SOURCE: '${SOURCE}'"
  echo "[$(timestamp)] -- BACKUP: -> TARGET: '${TARGET}'"

  TARGET_DATE=$(timestamp)
  ${CMD_MKDIR} -p ${TARGET}/${TARGET_DATE}
  ${CMD_CP} -a ${SOURCE}/* ${TARGET}/${TARGET_DATE}

}

# Get Arguments
shift $((OPTIND - 1))
SOURCE=$1
TARGET=$2
if [ -z "${SOURCE}" ]; then
  echo "[$(timestamp)] -- BACKUP: ERROR no SOURCE Path given, exit script"
  exit 1
fi
if [ -z "${TARGET}" ]; then
  echo "[$(timestamp)] -- BACKUP: ERROR no TARGET Path given, exit script"
  exit 1
fi

## Execute ##
create_backup




