#!/bin/bash
set -e

TARGET=$(cat /tmp/deploy-target)

echo "Target deployment: $TARGET"

sleep 30

cd /home/ubuntu/app/docker

for i in $(seq 1 20)
do
    STATUS=$(sudo docker exec ghost-nginx \
    curl -k -L -s -o /dev/null -w "%{http_code}" \
    -H "Host: ghostapp.duckdns.org" \
    http://ghost-$TARGET:2368)

    echo "STATUS=$STATUS"

    if [ "$STATUS" = "200" ]; then
        docker inspect ghost-blue | grep ghost-logs
        docker inspect ghost-green | grep ghost-logs
        echo "Health check passed"

        CURRENT=$(cat /data/current-color)

        echo "Current active: $CURRENT"
        echo "Switching to: $TARGET"

        if [ "$TARGET" = "green" ]; then

            sed -i 's/server ghost-blue:2368;/server ghost-green:2368;/g' nginx/default.conf

        else

            sed -i 's/server ghost-green:2368;/server ghost-blue:2368;/g' nginx/default.conf

        fi

        echo "Restarting nginx"

        sudo docker exec ghost-nginx nginx -t && docker exec ghost-nginx nginx -s reload

        echo "$TARGET" | sudo tee /data/current-color

        echo "Traffic switched successfully to $TARGET"

        exit 0
    fi

    echo "Health check failed, retrying..."

    sleep 5
done

echo "Deployment failed after 20 attempts"

exit 1