#!/bin/bash

selected=$(docker ps | fzf)


id=$(echo "$selected" | awk '{print $1}')

docker kill $id



error_output=$(docker exec -it $selected bash 2>&1)