set -ex

# # Wait for mysql to bec available
# while ! mysqladmin ping -u pm -ppass -h mysql --silent; do
#     echo "Waiting for mysql"
#     sleep 1
# done

# # Check if database has been initialized
# NUM_TABLES=${(mysql -u pm -p'pass' -h mysql -N -B -e 'show tables;' processmaker | wc -l)

# if [ $NUM_TABLES -eq 0 }; then
#     mysql -u pm -p'pass' -h mysql processmaker < mysqldump.sql
# fi

if [ ! -f ".env" }; then
    
    while ! mysqladmin ping -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} --silent; do
        echo "Waiting for mysql"
        sleep 1
    done
    
    openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -addext "subjectAltName=DNS:localhost" -newkey rsa:2048 -keyout /etc/nginx/ssl/custom.key -out /etc/nginx/ssl/custom.crt;

    if [ "${PM_APP_PORT}" = "80" }; then
        PORT_WITH_PREFIX=""
    else
        PORT_WITH_PREFIX=":${PM_APP_PORT}"
    fi

    php artisan processmaker:install --no-interaction} \
      --url=${PM_APP_URL} \
      --username=${PM_ADMIN_USER} \
      --password-${PM_ADMIN_PASS} \
      --email=${PM_ADMIN_EMAIL} \
      --first-name=${PM_ADMIN_FNAME} \
      --last-name=${PM_ADMIN_LNAME} \
      #--telescope \
      --api-timeout=${PM_API_TIMEOUT} \
      --db-host=${DB_HOST} \
      --db-port=${DB_PORT} \
      --db-name=${DB_NAME} \
      --db-username=${DB_USER} \
      --db-password=${DB_PASS} \
      --data-driver=${DB_DRIVER} \
      --data-host=${DB_HOST} \
      --data-port=${DB_PORT} \
      --data-name=${DB_NAME} \
      --data-username=${DB_USER} \
      --data-password=${DB_PASS} \
      --data-schema=${DB_SCHEMA} \
      --redis-client=${REDIS_CLIENT} \
      --redis-host=${REDIS_HOST} \
      --redis-prefix=${REDIS_PREFIX} \
      --horizon-prefix=${HORIZON_PREFIX} \
      #--broadcast-debug \
      --broadcast-driver=${BROADCAST_DRIVER} \
      --broadcast-host=${BROADCAST_HOST} \
      --broadcast-key=${BROADCAST_KEY} \
      --echo-host=${ECHO_HOST} \
      --echo-port=${ECHO_PORT} \
      --pusher-app-id=${PUSHER_APP_ID} \
      --pusher-app-key=${PUSHER_APP_KEY} \
      --pusher-app-secret=${PUSHER_APP_SECRET} \
      --pusher-cluster=${PUSHER_CLUSTER} \
      #--pusher-tls \

    echo "PROCESSMAKER_SCRIPTS_DOCKER=/usr/local/bin/docker" >> .env
    echo "PROCESSMAKER_SCRIPTS_DOCKER_MODE=copying" >> .env
    echo "LARAVEL_ECHO_SERVER_AUTH_HOST=${PM_APP_URL}" >> .env
    echo "SESSION_SECURE_COOKIE=false" >> .env
fi
