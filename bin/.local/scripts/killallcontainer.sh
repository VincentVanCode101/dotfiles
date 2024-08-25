#!/bin/bash

for CONTAINER_ID in $(docker ps -q); do 
    docker kill $CONTAINER_ID 
done
