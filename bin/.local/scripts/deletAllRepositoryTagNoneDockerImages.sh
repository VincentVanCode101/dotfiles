#!/bin/bash

images=$(docker images | awk '$1 == "<none>" && $2 == "<none>" {print $3}')

for image in $images; do
    sudo docker image rm -f $image
done