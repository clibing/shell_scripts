#!/bin/bash
# function: docker clean image
# date    : 2018-10-22
# author  : clibing
# email   : wmsjhappy@gmail.com

set -e

TZ='Asia/Shanghai'

function setlocale(){
    if [ -f "/etc/centos-release" ];then
        echo "centos..."
        cat > /etc/locale.conf <<EOF
LANG="zh_CN.UTF-8"
EOF
    else
        echo "ubuntu..."
        locale-gen --purge en_US.UTF-8 zh_CN.UTF-8
        echo 'LANG="en_US.UTF-8"' > /etc/default/locale
        echo 'LANGUAGE="en_US:en"' >> /etc/default/locale
    fi

}

function settimezone(){
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
    echo ${TZ} > /etc/timezone
    if [ -f "/etc/centos-release" ];then
        timedatectl set-timezone Asia/Shanghai
    fi
}

setlocale
settimezone
