# ====================================================================================================================
# VERSION: 0.1.2
# ====================================================================================================================

# Base image
FROM ubuntu:noble

# Define
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

# Setup Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update & Upgrade
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean -y

# ====================================================================================================================


ARG CONTAINER_GID=10000
ARG CONTAINER_UID=10000

ENV STEAM_APP_ID="2278520"
ENV HOME="/home/steam"
ENV ENSHROUDED_PATH="/home/steam/enshrouded"
ENV ENSHROUDED_CONFIG="${ENSHROUDED_PATH}/enshrouded_server.json"
ENV EXTERNAL_CONFIG=0
ENV GE_PROTON_VERSION="9-25"
ENV GE_PROTON_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz"
ENV STEAMCMD_PATH="/home/steam/steamcmd"
ENV STEAM_SDK64_PATH="/home/steam/.steam/sdk64"
ENV STEAM_SDK32_PATH="/home/steam/.steam/sdk32"
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAMCMD_PATH"
ENV STEAM_COMPAT_DATA_PATH="${STEAMCMD_PATH}/steamapps/compatdata/${STEAM_APP_ID}"
ENV UMU_ID=0
# BACKUP VARIABLES
ENV BACKUP_SCRIPT="/backup.sh"
ENV BACKUP_CRONJOB_FILE_NAME="enshouded-cron"
ENV BACKUP_CRONJOB_FILE_PATH="/etc/cron.d/$BACKUP_CRONJOB_FILE_NAME"
ENV BACKUP_SOURCE="$ENSHROUDED_PATH/savegame"
ENV BACKUP_TARGET="${ENSHROUDED_PATH}/backup"
ENV BACKUP_LOGFILE="$ENSHROUDED_PATH/logs/enshrouded_server.log"


RUN groupadd -g $CONTAINER_GID steam \
    && useradd -g $CONTAINER_GID -u $CONTAINER_UID -m steam \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        procps \
        ca-certificates \
        winbind \
        dbus \
        libfreetype6 \
        curl \
        jq \
        locales \
        lib32gcc-s1 \
        cron \
        vim \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y

# Copy Entrypoint (all scipts must be in root, else will not update if the data volume was not removed = upgrade procedure)
COPY scripts/entrypoint.sh /entrypoint.sh
# Set permission
RUN chmod +x /entrypoint.sh


# BACKUP FEATURE
## Copy enshouded-cron file to the cron.d directory
COPY config/enshouded-cron $BACKUP_CRONJOB_FILE_PATH
## Give execution rights on the cron job
RUN chmod 0644 $BACKUP_CRONJOB_FILE_PATH
## Give execution rights on the cron job
RUN chown $CONTAINER_GID:$CONTAINER_GID $BACKUP_CRONJOB_FILE_PATH
# Give the necessary rights to the user to run the cron
RUN crontab -u steam $BACKUP_CRONJOB_FILE_PATH && chmod u+s /usr/sbin/cron
## Copy Backup script
COPY scripts/backup.sh $BACKUP_SCRIPT
RUN chmod +x $BACKUP_SCRIPT


USER steam

RUN mkdir "$ENSHROUDED_PATH" \
    && mkdir -p "${BACKUP_SOURCE}" \
    && mkdir -p "${BACKUP_TARGET}" \
    && mkdir -p "${STEAMCMD_PATH}/compatibilitytools.d" \
    && mkdir -p "${STEAMCMD_PATH}/steamapps/compatdata/${STEAM_APP_ID}" \
    && curl -sqL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxvf - -C ${STEAMCMD_PATH} \
    && chmod +x ${STEAMCMD_PATH}/steamcmd.sh \
    && ${STEAMCMD_PATH}/steamcmd.sh +quit \
    && mkdir -p /home/steam/.steam \
    && ln -s ${STEAMCMD_PATH}/linux64 ${STEAM_SDK64_PATH} \
    && ln -s ${STEAM_SDK64_PATH}/steamclient.so ${STEAM_SDK64_PATH}/steamservice.so \
    && ln -s ${STEAMCMD_PATH}/linux32 ${STEAM_SDK32_PATH} \
    && ln -s ${STEAM_SDK32_PATH}/steamclient.so ${STEAM_SDK32_PATH}/steamservice.so \
    && curl -sqL "$GE_PROTON_URL" | tar zxvf - -C "${STEAMCMD_PATH}/compatibilitytools.d/"


# Copy enshreouded config file
COPY config/enshrouded_server_example.json /enshrouded_server_example.json

WORKDIR /home/steam

CMD ["/entrypoint.sh"]