#!/bin/bash
# ---------------------------------------------------------------------------------------------------------------------
# CRONJOB:
# EVERY HOUR:  PATH OF SCRIPT:     SOURCE (which should backuped):  TARGET (copy to this location):  LOG FILE PATH:
# 0 * * * * /home/steam/backup.sh /home/steam/enshrouded/savegame /home/steam/enshrouded/backup /home/steam/enshrouded/logs/enshrouded_server.log
# OR
# 0 * * * * /home/gix/backup_enshrouded.sh /var/lib/docker/volumes/enshrouded_gameix-enshrouded-persistent-savegame/_data/ /home/gix/enshrouded_backup/ /home/gix/enshrouded_backup/backup.log
# ---------------------------------------------------------------------------------------------------------------------

# CMD
CMD_CP="/usr/bin/cp"
CMD_MKDIR="/usr/bin/mkdir"
CMD_ECHO="/usr/bin/echo"
CMD_DATE="/usr/bin/date"
CMD_LS="/usr/bin/ls"
CMD_DU="/usr/bin/du"
CMD_TEE="/usr/bin/tee"

# Generate a timestamp
timestamp () {
  ${CMD_DATE} +"%Y-%m-%d %H:%M:%S,%3N"
}

# Get size of folder
function get_size() {
  ${CMD_DU} -h --max-depth=0 "${1}" | awk '{ print $1 }'
}

# Remove backup files
function remove_backup_files(){
  if [ -z "${BACKUP_ARCHIVE_TIME_DAYS}" ]; then
    ${CMD_ECHO} "[$(timestamp)] -- BACKUP: WARN no BACKUP_ARCHIVE_TIME_DAYS given, exit to remove backup files" | ${CMD_TEE} -a "${BACKUP_ARCHIVE_TIME_DAYS}"
    exit 1
  else
    ${CMD_ECHO} "[$(timestamp)] -- BACKUP: INFO Remove backup files there are older then '${BACKUP_ARCHIVE_TIME_DAYS}' days" | ${CMD_TEE} -a "${BACKUP_ARCHIVE_TIME_DAYS}"
    #/usr/bin/find "${TARGET}" -type d -mtime +"${BACKUP_ARCHIVE_TIME_DAYS}" -delete
    /usr/bin/find "${TARGET}" -type d -mmin +"${BACKUP_ARCHIVE_TIME_DAYS}" -delete
  fi
}

function create_backup() {
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Start Backup" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> SOURCE: '${SOURCE}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> TARGET: '${TARGET}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  ${CMD_ECHO} "[$(timestamp)] -- BACKUP: -> BACKUP_LOG_FILE: '${BACKUP_LOG_FILE}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"

  # If SOURCE not empty create a backup
  if [ -z "$( ${CMD_LS} -A "${SOURCE}" )" ]; then
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is empty skip backup" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
  else
     TARGET_DATE=$(${CMD_DATE} +"%Y-%m-%d_%HH%MM%SS_%Z")
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: --> SOURCE is not empty create backup to '${TARGET}/${TARGET_DATE}'" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
     ${CMD_MKDIR} -p "${TARGET}"/"${TARGET_DATE}"
     ${CMD_CP} -a "${SOURCE}"/ "${TARGET}/${TARGET_DATE}/"
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Backup created (Size: $(get_size "${TARGET}"/"${TARGET_DATE}"))" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
     # Remove Backup Files
     ${CMD_ECHO} "[$(timestamp)] -- BACKUP: Execute REMOVE BACKUP FILES"
     remove_backup_files
  fi
  ${CMD_ECHO} "--------------------------------------------------------------------------------------------------------------" | ${CMD_TEE} -a "${BACKUP_LOG_FILE}"
}

# Get Arguments
shift $((OPTIND - 1))
SOURCE=$1
TARGET=$2
BACKUP_LOG_FILE=$3
BACKUP_ARCHIVE_TIME_DAYS=$4   # not mandatory
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





