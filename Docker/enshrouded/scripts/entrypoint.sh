#!/bin/bash
# ====================================================================================================================
VERSION="0.1.1"
# ====================================================================================================================

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

shutdown () {
    echo ""
    echo "$(timestamp) INFO: Recieved SIGTERM, shutting down gracefully"
    kill -2 $enshrouded_pid
}

function backup () {
  if [ "${ENABLE_BACKUP}" == "true" ]; then
    # Summary
    echo "[$(timestamp)] -- INFO: SETUP BACKUP (Cron job)"
    echo "[$(timestamp)] -- INFO: -> Backup Script: ${BACKUP_SCRIPT}"
    echo "[$(timestamp)] -- INFO: -> Backup Cronjob: ${BACKUP_CRONJOB_FILE_PATH}"
    echo "[$(timestamp)] -- INFO: --> Backup Source: ${BACKUP_SOURCE}"
    echo "[$(timestamp)] -- INFO: --> Backup Target: ${BACKUP_TARGET}"
    echo "[$(timestamp)] -- INFO: --> Backup Log File: ${BACKUP_LOGFILE}"
    echo "+---------------------------------------------------------------------------------------------------------------"

    # Adjust cron job file
    ## copy default cronjob file temporary to change (REASON: /usr/bin/sed: couldn't open temporary file /etc/cron.d/sedZ7K83k: Permission denied)
    /usr/bin/cp "${BACKUP_CRONJOB_FILE_PATH}" /tmp/"${BACKUP_CRONJOB_FILE_NAME}"
    ## change it
    /usr/bin/sed -i "s|BACKUP_SCRIPT|$BACKUP_SCRIPT|g" /tmp/"${BACKUP_CRONJOB_FILE_NAME}"
    /usr/bin/sed -i "s|BACKUP_SOURCE|$BACKUP_SOURCE|g" /tmp/"${BACKUP_CRONJOB_FILE_NAME}"
    /usr/bin/sed -i "s|BACKUP_TARGET|$BACKUP_TARGET|g" /tmp/"${BACKUP_CRONJOB_FILE_NAME}"
    /usr/bin/sed -i "s|BACKUP_LOGFILE|$BACKUP_LOGFILE|g" /tmp/"${BACKUP_CRONJOB_FILE_NAME}"

    ## copy to cron.d path back
    /usr/bin/cp -f /tmp/"${BACKUP_CRONJOB_FILE_NAME}" "${BACKUP_CRONJOB_FILE_PATH}"
    ## remove temporary cron.d file
    /usr/bin/rm /tmp/"${BACKUP_CRONJOB_FILE_NAME}"

    # Start cron (in background)
    /usr/sbin/cron &
  fi
}

# Keep Container running
function keepContainerRunning () {
  while :
  do
    sleeptime=3
    echo "ENSHROUDED: Keep Container running...Press [CTRL+C], next run in ${sleeptime} seconds";	sleep ${sleeptime}
  done
}

# Set our trap
trap 'shutdown' TERM

# Validate arguments
echo "+------------------------+--------------------------------------------------------------------------------------"
echo "| VERSION: '${VERSION}'       |"
echo "+------------------------+"
if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME='GAMEIX.NET Enshrouded Containerized'
    echo "[$(timestamp)] -- WARN: SERVER_NAME Variable not set, using default: 'GAMEIX.NET Enshrouded Containerized'"
  else
    echo "[$(timestamp)] -- INFO: SERVER_NAME Variable is set: '${SERVER_NAME}'"
fi

if [ -z "$SERVER_PASSWORD" ]; then
    echo "[$(timestamp)] -- WARN: SERVER_PASSWORD Variable not set, server will be open to the public!"
  else
    echo "[$(timestamp)] -- INFO: SERVER_PASSWORD Variable is set: '${SERVER_PASSWORD}'"
fi

if [ -z "$GAME_PORT" ]; then
    GAME_PORT='15636'
    echo "[$(timestamp)] -- WARN: GAME_PORT Variable not set, using default: '15636'"
  else
    echo "[$(timestamp)] -- INFO: GAME_PORT Variable is set: '${GAME_PORT}'"
fi

if [ -z "$QUERY_PORT" ]; then
    QUERY_PORT='15637'
    echo "[$(timestamp)] -- WARN: QUERY_PORT Variable not set, using default: '15637'"
  else
    echo "[$(timestamp)] -- INFO: QUERY_PORT Variable is set: '${QUERY_PORT}'"
fi

if [ -z "$SERVER_SLOTS" ]; then
    SERVER_SLOTS='16'
    echo "[$(timestamp)] -- WARN: SERVER_SLOTS Variable not set, using default: '16'"
  else
    echo "[$(timestamp)] -- INFO: SERVER_SLOTS Variable is set: '${SERVER_SLOTS}'"
fi

if [ -z "$SERVER_IP" ]; then
    SERVER_IP='0.0.0.0'
    echo "[$(timestamp)] -- WARN: SERVER_IP Variable not set, using default: '0.0.0.0'"
  else
    echo "[$(timestamp)] -- INFO: SERVER_IP Variable is set: '${SERVER_IP}'"
fi

if [ -z "$ENABLE_CHAT" ]; then
    ENABLE_CHAT='true'
    echo "[$(timestamp)] -- WARN: ENABLE_CHAT Variable not set, using default: 'true'"
  else
    echo "[$(timestamp)] -- INFO: ENABLE_CHAT Variable is set: '${ENABLE_CHAT}'"
fi

if [ -z "$ENABLE_BACKUP" ]; then
    ENABLE_BACKUP='true'
    echo "[$(timestamp)] -- WARN: ENABLE_BACKUP Variable not set, using default: 'true'"
  else
    echo "[$(timestamp)] -- INFO: ENABLE_BACKUP Variable is set: '${ENABLE_BACKUP}'"
fi

if [ -z "${BACKUP_ARCHIVE_TIME_DAYS}" ]; then
    BACKUP_ARCHIVE_TIME_DAYS="3"
    echo "[$(timestamp)] -- WARN: BACKUP_ARCHIVE_TIME_DAYS Variable not set, using default: '3'"
  else
    echo "[$(timestamp)] -- INFO: BACKUP_ARCHIVE_TIME_DAYS Variable is set: '${BACKUP_ARCHIVE_TIME_DAYS}'"
fi
echo "+---------------------------------------------------------------------------------------------------------------"

# Setup Backup
backup

# Install/Update Enshrouded
echo "[$(timestamp)] -- INFO: Updating Enshrouded Dedicated Server"
${STEAMCMD_PATH}/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$ENSHROUDED_PATH" +login anonymous +app_update ${STEAM_APP_ID} validate +quit

# Check that steamcmd was successful
if [ $? != 0 ]; then
    echo "[$(timestamp)] -- ERROR: steamcmd was unable to successfully initialize and update Enshrouded"
    exit 1
fi

# Copy example server config if not already present
if [ $EXTERNAL_CONFIG -eq 0 ]; then
    if ! [ -f "${ENSHROUDED_PATH}/enshrouded_server.json" ]; then
        echo "[$(timestamp)] -- INFO: Enshrouded server config not present, copying example"
        cp /enshrouded_server_example.json ${ENSHROUDED_PATH}/enshrouded_server.json
    fi
fi

# Check for proper save permissions
if ! touch "${ENSHROUDED_PATH}/savegame/test"; then
    echo ""
    echo "[$(timestamp)] -- ERROR: The ownership of /home/steam/enshrouded/savegame is not correct and the server will not be able to save..."
    echo "the directory that you are mounting into the container needs to be owned by 10000:10000"
    echo "from your container host attempt the following command 'chown -R 10000:10000 /your/enshrouded/folder'"
    echo ""
    exit 1
fi

rm "${ENSHROUDED_PATH}/savegame/test"

# Modify server config to match our arguments
if [ $EXTERNAL_CONFIG -eq 0 ]; then
    echo "[$(timestamp)] -- INFO: Updating Enshrouded Server configuration"
    tmpfile=$(mktemp)
    jq --arg n "$SERVER_NAME" '.name = $n' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    if [ -n "$SERVER_PASSWORD" ]; then
        jq --arg p "$SERVER_PASSWORD" '.userGroups[].password = $p' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    fi
    jq --arg g "$GAME_PORT" '.gamePort = ($g | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    jq --arg q "$QUERY_PORT" '.queryPort = ($q | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    jq --arg s "$SERVER_SLOTS" '.slotCount = ($s | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    jq --arg i "$SERVER_IP" '.ip = $i' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    #jq --arg c "$ENABLE_CHAT" '.enableTextChat = $c' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
    # -> BUG: jq: error (at /home/steam/enshrouded/enshrouded_server.json:60): string ("true") cannot be parsed as a number
else
    echo "[$(timestamp)] -- INFO: EXTERNAL_CONFIG set to true, not updating Enshrouded Server configuration"
fi

# Wine talks too much and it's annoying
export WINEDEBUG=-all

# Check that log directory exists, if not create
if ! [ -d "${ENSHROUDED_PATH}/logs" ]; then
    mkdir -p "${ENSHROUDED_PATH}/logs"
fi

# Check that log file exists, if not create
if ! [ -f "${ENSHROUDED_PATH}/logs/enshrouded_server.log" ]; then
    touch "${ENSHROUDED_PATH}/logs/enshrouded_server.log"
fi

# Link logfile to stdout of pid 1 so we can see logs
ln -sf /proc/1/fd/1 "${ENSHROUDED_PATH}/logs/enshrouded_server.log"

# Launch Enshrouded
echo "[$(timestamp)] -- INFO: Starting Enshrouded Dedicated Server"
${STEAMCMD_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton run ${ENSHROUDED_PATH}/enshrouded_server.exe &

# Find pid for enshrouded_server.exe
timeout=0
while [ $timeout -lt 11 ]; do
    if ps -e | grep "enshrouded_serv"; then
        enshrouded_pid=$(ps -e | grep "enshrouded_serv" | awk '{print $1}')
        break
    elif [ $timeout -eq 10 ]; then
        echo "[$(timestamp)] -- ERROR: Timed out waiting for enshrouded_server.exe to be running"
        exit 1
    fi
    sleep 6
    ((timeout++))
    echo "[$(timestamp)] -- INFO: Waiting for enshrouded_server.exe to be running"
done

# Hold us open until we recieve a SIGTERM by opening a job waiting for the process to finish then calling `wait`
tail --pid=$enshrouded_pid -f /dev/null &
wait

# Handle post SIGTERM from here (SIGTERM will cancel the `wait` immediately even though the job is not done yet)
# Check if the enshrouded_server.exe process is still running, and if so, wait for it to close, indicating full shutdown, then go home
if ps -e | grep "enshrouded_serv"; then
    tail --pid=$enshrouded_pid -f /dev/null
fi

# o7
echo "[$(timestamp)] -- INFO: Shutdown complete."
exit 0