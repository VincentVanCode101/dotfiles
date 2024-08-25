#!/bin/bash

container_list=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}")

selected_container=$(echo "$container_list" | fzf --preview "docker logs --tail 10 {1}")

if [ -z "$selected_container" ]; then
    echo "No container selected. Abort."
    exit 1
fi

container_id=$(echo "$selected_container" | awk '{print $1}')


docker exec -it "$container_id" bash || docker exec -it "$container_id" sh

