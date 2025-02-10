# Enshrouded
Enshrouded Gameserver

## Link
[Setting Up an Enshrouded Dedicated Server on Ubuntu](https://github.com/bonsaibauer/enshrouded_server_ubuntu)
[Enshrouded Docker](https://github.com/jsknnr/enshrouded-server)

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
    docker rm -f ${repo}-gameserver

    # Remove current devloping image
    docker rmi -f ${repo}-gameserver:0.1.0
    
    # Remove all old docker images etc.
    docker system prune -af --volumes
    
    # Build & Deploy 
    docker-compose up -d
    cd /opt
    
    # Show logs
    docker logs -f ${repo}-gameserver


### INFO
* Size of Docker image ~ 2GB
* Size min. Disk (gameserver data etc.) ~ 6GB


### Run (without docker-compose)
    docker volume create enshrouded-persistent-data
    docker run \
    --detach \
    --name gameix-enshrouded-server \
    --mount type=volume,source=enshrouded-persistent-data,target=/home/steam/enshrouded/savegame \
    --publish 15636:15636/udp \
    --publish 15637:15637/udp \
    --env=SERVER_NAME='GAMEIX Enshrouded Server' \
    --env=SERVER_SLOTS=16 \
    --env=SERVER_PASSWORD='ChangeThisPlease' \
    --env=GAME_PORT=15636 \
    --env=QUERY_PORT=15637 \
    enshrouded-gameserver:0.1.0


### Client Connect
* Via IPv4: <IPv4>:<QueryPost=15637>
* Via Name: GAMEIX Enshrouded Server

#### Show detailed disk usage of root
    du -cha --max-depth=1 / | grep -E "M|G"

#### Show detailed disk usage subdirs
    du -bsh *


## Use existing Docker image [Enshrouded Docker](https://github.com/jsknnr/enshrouded-server)
    docker rm -f enshrouded-server 
    docker volume create enshrouded-persistent-data
    docker run \
    --detach \
    --name enshrouded-server \
    --mount type=volume,source=enshrouded-persistent-data,target=/home/steam/enshrouded/savegame \
    --publish 15636:15636/udp \
    --publish 15637:15637/udp \
    --env=SERVER_NAME='gameix' \
    --env=SERVER_SLOTS=16 \
    --env=SERVER_PASSWORD='WuppiDuppi12!' \
    --env=GAME_PORT=15636 \
    --env=QUERY_PORT=15637 \
    sknnr/enshrouded-dedicated-server:latest
    # show logs
    docker logs -f enshrouded-server

