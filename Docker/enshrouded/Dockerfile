# INFO: ETCD
###############################################################
#
# Base image
FROM enshrouded-base:0.1.0

# Install Required Packages
RUN apt-get install -y software-properties-common lsb-release wget

# Install Wine Installation
#RUN apt-get install -y


# Clean up
RUN apt-get autoremove -y && apt-get clean -y

# copy scripts
COPY scripts/entrypoint.sh /root/entrypoint.sh

# set permission to scripts
RUN chmod +x /root/entrypoint.sh

# run filesyc container
CMD [ "/root/entrypoint.sh" ]