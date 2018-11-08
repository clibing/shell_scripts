#!/bin/bash
# function: docker clean image
# date    : 2018-10-22
# author  : clibing
# email   : wmsjhappy@gmail.com

set -e


TARGET=${TARGET:-"/tmp"}
DAYS=${DAYS:-"7"}
DELETED=${DELETED:-"no"}

while getopts "p:t:d:" OPT; do
    case $OPT in
        p)
            TARGET=$OPTARG;;
        t)
            DAYS=$OPTARG;;
        d)
            DETELED=$OPTARG;;
    esac
done

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo -e "this.sh -p target_file_dir -t before_days -d is_sure_delete"
    echo -e "-p: target file path\n-t: will delete before days\n-d: sure delete, 'yes'|'no'"
    echo -e "such as: this.sh -p /tmp -t 7 -d yes"
    exit 1
fi
if [ "${DETELED}" = "yes" ]; then
    find ${TARGET}/ -type f -mtime +${DAYS} -exec rm -f {} \; 
else
    find ${TARGET}/ -type f -mtime +${DAYS} -exec ls -l {} \; 
fi

