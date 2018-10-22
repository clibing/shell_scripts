#!/bin/bash
# function: docker clean image
# date    : 2018-10-22
# author  : clibing
# email   : wmsjhappy@gmail.com

docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker stop
docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm
docker images | grep none | grep -v REPOSITORY | awk '{print $3 }' | xargs docker rmi
