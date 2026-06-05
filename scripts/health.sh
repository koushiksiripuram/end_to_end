#!/bin/bash
set -e

TARGET=$(cat /tmp/deploy-target)

echo "Target deployment: $TARGET"

sleep 30

cd /home/ubuntu/app/docker

for i in $(seq 1 20)
do
    STATUS=$(sudo docker exec ghost-nginx \
        curl -s -o /dev/null -w "%{http_code}" \
        http://ghost-$TARGET:2368)

    echo "Attempt $i - HTTP Status: $STATUS"

    if [ "$STATUS" = "200" ] || \
       [ "$STATUS" = "301" ] || \
       [ "$STATUS" = "302" ]; then

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

        sudo docker exec ghost-nginx nginx -s reload

        echo "$TARGET" | sudo tee /data/current-color

        echo "Stopping old environment: $CURRENT"

        sudo docker stop ghost-$CURRENT || true

        echo "Traffic switched successfully to $TARGET"

        exit 0
    fi

    echo "Health check failed, retrying..."

    sleep 5
done

echo "Deployment failed after 20 attempts"

exit 1