#!/bin/bash

container_list=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}")

selected_container=$(echo "$container_list" | fzf --preview "docker logs --tail 10 {1}")

if [ -z "$selected_container" ]; then
    echo "No container selected. Abort."
    exit 1
fi

container_id=$(echo "$selected_container" | awk '{print $1}')

if docker exec "$container_id" which bash > /dev/null 2>&1; then
    docker exec -it "$container_id" bash
elif docker exec "$container_id" which sh > /dev/null 2>&1; then
    docker exec -it "$container_id" sh
else
    echo "Failed to connect to container. Neither bash nor sh is available."
    exit 1
fi