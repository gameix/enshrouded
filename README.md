# Enshrouded 0.1.1
Enshrouded Gameserver

## CHANGELOG
### 0.1.1
* Add Backup Feature
### 0.1.0
* create docker image 

## Link
* [Enshrouded Docker](https://github.com/jsknnr/enshrouded-server)
* [Enable voice and chat:](https://steamcommunity.com/sharedfiles/filedetails/?id=3417090067)
* [Recommended Server Specifications ](https://enshrouded.zendesk.com/hc/en-us/articles/16055628734109-Recommended-Server-Specifications)

### Build & Deployment

#### Docker-Compose installation
    # To download and install Compose standalone, run:
    curl -SL https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    # Apply executable permissions to the standalone binary in the target path for the installation.
    chmod +x /usr/local/bin/docker-compose
    # Verify installation
    /usr/local/bin/docker-compose --version

#### Build All Images & Deploy
    # Clone git repo
    repo="enshrouded"
    version="0.1.1"
    cd /opt
    rm -rf /opt/${repo}
    git clone https://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@github.com/gameix/${repo}.git
    cd /opt/${repo}
    # Checkout Branch
    git checkout backup-feature
    git branch -a

    # Remove existing all containers
    docker rm -f gameix-enshrouded-gameserver

    # Remove current devloping image
    docker rmi -f gameix-enshrouded-gameserver:${version}
    
    # Remove all old docker images etc.
    docker system prune -af --volumes

    # Remove existing volume
    docker volume rm -f enshrouded_gameix-enshrouded-persistent-data
    #docker volume rm -f enshrouded_gameix-enshrouded-persistent-savegame
    #docker volume rm -f enshrouded_gameix-enshrouded-persistent-backup
    sync

    # Build & Deploy 
    docker-compose up -d 
    cd /opt
    
    # Show logs
    docker logs -f gameix-enshrouded-gameserver

### Run/Update (with docker-compose no gameserver data will be lost)
    # Clone git repo
    repo="enshrouded"
    version="0.1.1"
    cd /opt
    rm -rf /opt/${repo}
    git clone https://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@github.com/gameix/${repo}.git
    cd /opt/${repo}
    # Checkout Branch
    git checkout backup-feature
    git branch -a

    # Remove existing all containers
    docker rm -f gameix-enshrouded-gameserver

    # Remove current devloping image
    docker rmi -f gameix-enshrouded-gameserver:${version}
    
    # Remove all old docker images etc.
    docker system prune -af --volumes

    # Build & Deploy 
    docker-compose up -d
    cd /opt
    
    # Show logs
    docker logs -f gameix-enshrouded-gameserver

### Run (without docker-compose)
    docker volume create enshrouded-persistent-data
    docker run \
    --detach \
    --name enshrouded-gameserver \
    --mount type=volume,source=enshrouded-persistent-data,target=/home/steam \
    --publish 15636:15636/udp \
    --publish 15637:15637/udp \
    --env=SERVER_NAME='GAMEIX Enshrouded Server' \
    --env=SERVER_SLOTS=16 \
    --env=SERVER_PASSWORD='WuppiDuppi12!' \
    --env=GAME_PORT=15636 \
    --env=QUERY_PORT=15637 \
    enshrouded-gameserver:0.1.0


### Client Connect
* Via IPv4: <IPv4>:<QueryPost=15637>
* Via Name: GAMEIX.NET Enshrouded Server


### INFO
* Size of Docker image ~ 2GB
* Size min. Disk (gameserver data etc.) ~ 6GB


### Backup & Restore (World Data)
#### Backup
    # create a backup location
    BACKUP_PATH="/opt/enshrouded_backup"
    mkdir -p ${BACKUP_PATH}
    # copy world data to a save location
    cp -a /var/lib/docker/volumes/enshrouded_gameix-enshrouded-persistent-savegame/_data/* ${BACKUP_PATH}/
#### Restore
    # create a backup location
    BACKUP_PATH="/opt/enshrouded_backup"
    # Stop gameserver
    docker stop gameix-enshrouded-gameserver
    # remove existing files
    rm -f /var/lib/docker/volumes/enshrouded_gameix-enshrouded-persistent-savegame/_data/*
    # copy world data to world path
    cp -a ${BACKUP_PATH}/* /var/lib/docker/volumes/enshrouded_gameix-enshrouded-persistent-savegame/_data/
    # set permission
    chown 10000:10000 /var/lib/docker/volumes/enshrouded_gameix-enshrouded-persistent-savegame/_data/*
    # Start gameserver
    docker start gameix-enshrouded-gameserver

#### Show detailed disk usage of root
    du -cha --max-depth=1 / | grep -E "M|G"

#### Show detailed disk usage subdirs
    du -bsh *

## BUGS
    # Error in entrypoint.sh line 98
        -> jq: error (at /home/steam/enshrouded/enshrouded_server.json:60): string ("true") cannot be parsed as a number
    # Update image:
        -> /home/steam/entrypoint.sh will not updated with new !!
        --> WORKAROUND: remove enshrouded_gameix-enshrouded-persistent-data docker volume
        ---> SOLUTION: this file should not be in /home/steam folder 

# The Virtualbox Appliance
    Idea: 
    ich hoste den gameserver auf meinem PC (da super CPU und 1gbit up link) in einer virtual VM (eine appliance, kann auch für VMWAre oder anderne Hypervisors) wo linux und der gameserver läuft wo sich die läute dann connecten können.
    Eine einfache lösung um schnell den gameserver von hetzer zb. welcher immer läuft aber nur mit wenigern spielern. Und keinen Hoster verwenden zu müssen.
    Man könnte auch filesyc in spiel nehmen um z.b. die dataen auf den main gamerserver immer abzugleichen (world speicher stände)....

