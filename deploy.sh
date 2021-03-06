#!/bin/bash

# shellcheck disable=SC1091
source conf
trap remove_services INT

remove_services() {
    docker-compose down
    exit 0
}

# perform end point /app health check with curl
app_health_check(){
    CURRENT_STATUS=$(curl -s -w "%{http_code}\n" -o /dev/null  "$URL"/app)
    if [ "$CURRENT_STATUS" = "200" ];
    then echo "Endpoint up"
    else echo "Endpoint down"
    fi
}

# deploy instancs using docker compose.
deploy_services() {
    #list services
    echo "Deploy services:"
    printf "%s \n" "$(sudo docker-compose ps --services)"
    docker-compose up --detach
}

#main
main() {
    
    deploy_services
    while true; do 
        app_health_check    
        sleep 10s
    done
}

main





