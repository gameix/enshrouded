##!/bin/bash



# Keep Container running
function keepContainerRunning () {
  # Keep Alive
  while :
  do
    sleeptime=10
    echo "Keep Container running...Press [CTRL+C], next run in ${sleeptime} seconds";	sleep ${sleeptime}
  done
}

#########################################################
#
# Execute
keepContainerRunning