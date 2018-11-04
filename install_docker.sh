#!/bin/bash
# function: docker install 
# date    : 2018-11-04
# author  : clibing
# email   : wmsjhappy@gmail.com

set -e

registry=${registry:-"127.0.0.1:5000"}

while getopts "s:" OPT; do
    case $OPT in
        s)
            registry=$OPTARG;;
    esac
done

function installDep(){
    apt install curl -y
}

function installDocker(){
    curl -sSL https://get.docker.com/ | sh
}

function installConfig(){
   label_name=`hostname`
   mkdir -p /etc/systemd/system/docker.service.d
   touch /etc/systemd/system/docker.service.d/docker.conf
   cat > /etc/systemd/system/docker.service.d/docker.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D -H fd:// \
                              -H tcp://0.0.0.0:2375 \
                              -H unix:///var/run/docker.sock \
                              --storage-driver=overlay2 \
                              --graph=/var/lib/docker \
                              --log-driver json-file \
                              --log-opt max-size=100m \
                              --log-opt max-file=3 \
                              --log-opt labels=${label_name} \
                              --insecure-registry ${registry}
EOF
}

installDep
installDocker
installConfig
systemctl daemon-reload
systemctl docker restart



