# INFO: ETCD
###############################################################
#
# Base image
FROM enshrouded-base:0.1.0

# Install Required Packages
RUN apt-get install -y software-properties-common lsb-release wget

# Install Wine Installation
## Create Keyring Directory
RUN mkdir -pm755 /etc/apt/keyrings
## Download Wine GPG Key
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
## Add Wine Repository
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources
## Add a new architecture
RUN dpkg --add-architecture i386
## Update and Install Wine
RUN apt-get update && apt-get install -y --install-recommends winehq-staging
## We need a few extra packages for Wine to work with the Enshrouded dedicated server on Ubuntu.
RUN apt-get install -y cabextract winbind screen xvfb
## Add the multiverse repository to our Ubuntu device
RUN add-apt-repository multiverse


# Install Steam
## Add automatically License aggreement
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections
## Install steamcmd
RUN apt-get install -y steamcmd


# Install Enshrouded Dedicated Server
## Add User
RUN useradd -m enshrouded
RUN sudo -u enshrouded -s






# Clean up
RUN apt-get autoremove -y && apt-get clean -y

# copy scripts
COPY scripts/entrypoint.sh /root/entrypoint.sh

# set permission to scripts
RUN chmod +x /root/entrypoint.sh

# run filesyc container
CMD [ "/root/entrypoint.sh" ]