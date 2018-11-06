#!/bin/bash
# function: docker clean image
# date    : 2018-10-22
# author  : clibing
# email   : wmsjhappy@gmail.com

set -e


DESCRIPTION=${DESCRIPTION:-"description this line"}
TOKEN=${TOKEN:-"token"}
EXECUTE_FILE=${EXECUTE_FILE:-"/usr/local/bin/exec.sh"}
SYSTEMCTL_SERVICE_NAME=${SYSTEMCTL_SERVICE_NAME:-"custom"}
HELP=${HELP:-""}

function help(){
    echo -e "help function"
}
while getopts "d:t:e:n:h:" OPT; do
    case $OPT in
        h)
            DESCRIPTION=$OPTARG;;
        t)
            TOKEN=$OPTARG;;
        e)
            EXECUTE_FILE=$OPTARG;;
        n)
            SYSTEMCTL_SERVICE_NAME=$OPTARG;;
        h)
            HELP="help"
    esac
done

if [ "${HELP}" = "help" ]; then
    help
    exit 1
fi

cat > /lib/systemd/system/${SYSTEMCTL_SERVICE_NAME}.service <<EOF
# create by shell
[Unit]
Description=${DESCRIPTION}
After=syslog.target

[Service]
SyslogIdentifier=${TOKEN}
ExecStart=${EXECUTE_FILE}
Type=simple

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ${SYSTEMCTL_SERVICE_NAME}.service
