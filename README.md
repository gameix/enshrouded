# Enshrouded
Enshrouded Gameserver

## Link
* [Enshrouded Docker](https://github.com/jsknnr/enshrouded-server)

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
    cd /opt
    rm -rf /opt/${repo}
    git clone https://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@github.com/gameix/${repo}.git
    cd /opt/${repo}
    # Checkout Branch
    git checkout create-docker-image
    git branch -a

    # Remove existing all containers
    docker rm -f gameix-enshrouded-gameserver

    # Remove current devloping image
    docker rmi -f gameix-enshrouded-gameserver:0.1.0
    
    # Remove all old docker images etc.
    docker system prune -af --volumes

    # Remove existing volume
    docker volume rm -f enshrouded_gameix-enshrouded-persistent-data
    sync

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
* Via Name: GAMEIX Enshrouded Server


### INFO
* Size of Docker image ~ 2GB
* Size min. Disk (gameserver data etc.) ~ 6GB


#### Show detailed disk usage of root
    du -cha --max-depth=1 / | grep -E "M|G"

#### Show detailed disk usage subdirs
    du -bsh *

## BUGS
    # Error in entrypoint.sh line 98
        -> jq: error (at /home/steam/enshrouded/enshrouded_server.json:60): string ("true") cannot be parsed as a number
