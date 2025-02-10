#!/bin/bash

# Run STEAM ENSHROUDED DEDICATED SERVER
function enshrouded_dedicated_server() {
  echo "ENSHROUDED: Start Dedicated Server"
  wine64 ~/enshroudedserver/enshrouded_server.exe



}


# Keep Container running
function keepContainerRunning () {
  # Keep Alive
  while :
  do
    sleeptime=10
    echo "ENSHROUDED: Keep Container running...Press [CTRL+C], next run in ${sleeptime} seconds";	sleep ${sleeptime}
  done
}

#########################################################
#
# Execute
keepContainerRunning
enshrouded_dedicated_server