# Enshrouded
Enshrouded gameserver

## Link
[Setting Up an Enshrouded Dedicated Server on Ubuntu](https://github.com/bonsaibauer/enshrouded_server_ubuntu)

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
    #docker system prune -af --volumes
    
    # Build & Deploy 
    docker-compose up -d
    cd /opt
    
    # Show logs
    docker logs -f ${repo}-gameserver



### INFO
* Size of Docker image ~ 9GB
* 