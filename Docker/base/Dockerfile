# INFO: BASE
###############################################################
#
# Base image
FROM ubuntu:noble

# Define
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

# Setup Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update & Upgrade
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean -y

