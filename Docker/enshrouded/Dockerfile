# INFO: ETCD
###############################################################
#
# Base image
FROM enshrouded-base:0.1.0

# Install Tools
RUN apt-get install -y --no-install-recommends etcd-client etcd-server
# remove apt-get etc and not needed tools and commands -> Security

# Clean up
RUN apt-get autoremove -y && apt-get clean -y

# copy scripts
COPY scripts/entrypoint.sh /root/entrypoint.sh

# set permission to scripts
RUN chmod +x /root/entrypoint.sh

# run filesyc container
CMD [ "/root/entrypoint.sh" ]