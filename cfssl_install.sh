#!/bin/bash
# function: cfssl install
# date    : 2018-11-07
# author  : clibing
# email   : wmsjhappy@gmail.com

set -e 

version=${version:-"1.2"}
target=${target:-"/usr/local/bin/"}

while getopts "v:" OPT; do
    case $OPT in
        v)
            version=$OPTARG;;
    esac
done


function download(){
    version=$1
    save_path=$2
    kernel_name=`uname -s`
    if [ ${kernel_name} = 'Darwin' ]; then
        kernel_name="darwin"
    fi
    if [ ${kernel_name} = 'Linux' ]; then
        kernel_name="linux"
    fi

    machine_hardware_name=`uname -m`
    # x64_64
    if [ ${machine_hardware_name} = 'x86_64' ]; then
        machine_hardware_name="amd64"
    fi
    # aarch64 
    if [ ${machine_hardware_name} = 'x86_64' ]; then
        machine_hardware_name="amd64"
    fi
    # arm
    if [ ${machine_hardware_name} = 'armhf' ]; then
        machine_hardware_name="arm"
    fi
    CFSSL_CERTINFO="https://pkg.cfssl.org/R${version}/cfssl-certinfo_${kernel_name}-${machine_hardware_name}"
    CFSSLJSON="https://pkg.cfssl.org/R${version}/cfssljson_${kernel_name}-${machine_hardware_name}"
    CFSSL="https://pkg.cfssl.org/R${version}/cfssl_${kernel_name}-${machine_hardware_name}"

    echo -e "will start download and save to ${save_path} ..."
    echo -e "CFSSL          : ${CFSSL}"
    echo -e "CFSSLJSON      : ${CFSSLJSON}"
    echo -e "CFSSL_CERTINFO : ${CFSSL_CERTINFO}"

    # create tmp will test permissions
    touch ${save_path}/.download
    curl -o ${save_path}/cfssl-certinfo ${CFSSL_CERTINFO}
    curl -o ${save_path}/cfssljson ${CFSSLJSON}
    curl -o ${save_path}/cfssl ${CFSSL}
    chmod a+x  ${save_path}/cfssl-certinfo  ${save_path}/cfssljson ${save_path}/cfssl
    rm -rf ${save_path}/.download
}

download ${version} ${target}
