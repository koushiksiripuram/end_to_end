#!/bin/bash
set -e

TARGET=$(cat /tmp/deploy-target)

sleep 30

cd /home/ubuntu/app/docker

for i in $(seq 1 20)
do
    if sudo docker exec ghost-nginx \
       wget -qO- http://ghost-$TARGET:2368 >/dev/null 2>&1
    then

        echo "Health check passed"

        CURRENT=$(cat /data/current-color)

        if [ "$TARGET" = "green" ]; then

            sed -i 's/server ghost-blue:2368;/server ghost-green:2368;/g' nginx/default.conf

        else

            sed -i 's/server ghost-green:2368;/server ghost-blue:2368;/g' nginx/default.conf

        fi

        sudo docker exec ghost-nginx nginx -s reload

        echo $TARGET | sudo tee /data/current-color

        sudo docker rm -f ghost-$CURRENT || true

        echo "Traffic switched to $TARGET"

        exit 0
    fi

    sleep 5
done

echo "Deployment failed"
exit 1