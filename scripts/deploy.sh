#!/bin/bash
set -e

sudo mkdir -p /data

if ! mountpoint -q /data; then

    if ! blkid /dev/nvme1n1 > /dev/null 2>&1; then
        sudo mkfs.ext4 /dev/nvme1n1
    fi

    sudo mount /dev/nvme1n1 /data

    grep -q "/data " /etc/fstab || \
    echo '/dev/nvme1n1 /data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
fi

sudo mkdir -p /data/ghost
sudo mkdir -p /data/mysql
sudo mkdir -p /data/certbot
sudo chown -R 999:999 /data/mysql
sudo mkdir -p /data/ghost-logs/blue
sudo mkdir -p /data/ghost-logs/green

sudo chmod -R 755 /data/ghost-logs
sudo chmod -R 755 /data/mysql

sudo chown -R 999:999 /data/ghost
sudo chmod -R 755 /data/ghost

sudo rm -rf app

if [ ! -f /data/certbot/conf/live/ghostapp.duckdns.org/fullchain.pem ]; then
    sudo tar -xzvf certbot-conf.tar.gz -C /data

    sudo chmod 755 /data/certbot/conf/live
    sudo chmod 755 /data/certbot/conf/live/ghostapp.duckdns.org
    sudo chmod 755 /data/certbot/conf/archive
    sudo chmod 755 /data/certbot/conf/archive/ghostapp.duckdns.org
fi

git clone https://github.com/koushiksiripuram/end_to_end.git app

mv /home/ubuntu/ghost.env /home/ubuntu/app/docker/.env

cd /home/ubuntu/app/docker

cd ../scripts

chmod +x install.sh
./install.sh

sudo systemctl enable docker
sudo systemctl start docker

cd ../docker

if [ ! -f /data/current-color ]; then
    echo blue | sudo tee /data/current-color
fi

CURRENT=$(cat /data/current-color)

if [ "$CURRENT" = "blue" ]; then
    DEPLOY_TARGET="green"
else
    DEPLOY_TARGET="blue"
fi

echo "Current: $CURRENT"
echo "Deploying: $DEPLOY_TARGET"
CURRENT_TAG=$(sudo docker inspect ghost-$CURRENT \
  --format='{{.Config.Image}}' | awk -F: '{print $NF}')
sed -i "/ghost-$CURRENT:/,/container_name:/ s|image: .*|image: ${IMAGE_NAME}:${CURRENT_TAG}|" docker-compose.yaml
sed -i "/ghost-$DEPLOY_TARGET:/,/container_name:/ s|image: .*|image: ${IMAGE_NAME}:${IMAGE_TAG}|" docker-compose.yaml

sudo docker compose pull

sudo docker compose up -d ghost-$DEPLOY_TARGET

echo $DEPLOY_TARGET > /tmp/deploy-target