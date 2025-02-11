#!/bin/bash

# CMD
CMD_CP="/usr/bin/cp"
CMD_MKDIR="/usr/bin/mkdir"
CMD_ECHO="/usr/bin/echo"
CMD_DATE="/usr/bin/date"
CMD_LS="/usr/bin/ls"
CMD_TEE="/usr/bin/tee"

# Quick function to generate a timestamp
timestamp () {
  ${CMD_DATE} +"%Y-%m-%d %H:%M:%S,%3N"
}

function create_backup() {
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Start Backup" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> SOURCE: '${SOURCE}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> TARGET: '${TARGET}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> BACKUP_LOG_FILE: '${BACKUP_LOG_FILE}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"

  if [ -z "$( ${CMD_LS} -A "${SOURCE}" )" ]; then
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is empty skip backup" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  else
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is not empty create backup" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
     TARGET_DATE=$(${CMD_DATE} +"%Y-%m-%d_%H%M%S")
     ${CMD_MKDIR} -p ${TARGET}/${TARGET_DATE}
     ${CMD_CP} -a ${SOURCE}/* ${TARGET}/${TARGET_DATE}
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Backup created" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  fi
}

# Get Arguments
shift $((OPTIND - 1))
SOURCE=$1
TARGET=$2
BACKUP_LOG_FILE=$3
if [ -z "${SOURCE}" ]; then
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: ERROR no SOURCE Path given, exit script" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  exit 1
fi
if [ -z "${TARGET}" ]; then
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: ERROR no TARGET Path given, exit script" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  exit 1
fi
if [ -z "${BACKUP_LOG_FILE}" ]; then
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: ERROR no BACKUP_LOG_FILE Path given, exit script" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  exit 1
fi
## Execute ##
create_backup




