#!/bin/bash

# CMD
CMD_CP="/usr/bin/cp"
CMD_MKDIR="/usr/bin/mkdir"
CMD_ECHO="/usr/bin/echo"
CMD_DATE="/usr/bin/date"
CMD_LS="/usr/bin/ls"

# Quick function to generate a timestamp
timestamp () {
  ${CMD_DATE} +"%Y-%m-%d %H:%M:%S,%3N"
}

function create_backup() {
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Start Backup"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> SOURCE: '${SOURCE}'"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> TARGET: '${TARGET}'"

  if [ -z "$( ${CMD_LS} -A "${SOURCE}" )" ]; then
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is empty skip backup"
  else
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is not empty create backup"
     TARGET_DATE=$(${CMD_DATE} +"%Y-%m-%d_%H%M%S")
     ${CMD_MKDIR} -p ${TARGET}/${TARGET_DATE}
     ${CMD_CP} -a ${SOURCE}/* ${TARGET}/${TARGET_DATE}
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Backup created"
  fi
}

# Get Arguments
shift $((OPTIND - 1))
SOURCE=$1
TARGET=$2
if [ -z "${SOURCE}" ]; then
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: ERROR no SOURCE Path given, exit script"
  exit 1
fi
if [ -z "${TARGET}" ]; then
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: ERROR no TARGET Path given, exit script"
  exit 1
fi

## Execute ##
create_backup




