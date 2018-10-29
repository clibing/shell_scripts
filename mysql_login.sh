#!/bin/bash

MYSQLHOST=${MYSQLHOST:-"127.0.0.1"}
MYSQLUSER=${MYSQLUSER:-"root"}
MYSQLPORT=${MYSQLPORT:-"3306"} 

while getopts "h:u:p:" OPT; do
    case $OPT in
        h)
            MYSQLHOST=$OPTARG;;
        u)
            MYSQLUSER=$OPTARG;;
        p)
            MYSQLPORT=$OPTARG;;
    esac
done

mysql \
-h ${MYSQLHOST} \
-u ${MYSQLUSER} \
-P ${MYSQLPORT} \
-p
