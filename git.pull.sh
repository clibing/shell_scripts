#!/bin/bash

set -e

async_pull(){
    cd $1 && git branch && git checkout master && git pull
}

GIT_HOME=${GIT_HOME:-""}

while getopts "h:" OPT; do
    case $OPT in
        h)
            GIT_HOME=$OPTARG;;
    esac
done

if [ -z ${GIT_HOME} ]; then
    echo -e "GIT_HOME is empty"
    exit 1
fi

echo -e "GIT_HOME: ${GIT_HOME}"

for FILE in `ls ${GIT_HOME}`
do
{
    if [ -d ${FILE} ]; then
        async_pull ${GIT_HOME}/${FILE}
        # sleep 5; echo "....."
    fi
}
# &
done

#echo -e "wait for execute end"
#wait
echo -e "async git pull end"
