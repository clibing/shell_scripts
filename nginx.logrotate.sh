#!/bin/bash
# function: nginx log 
# date    : 2018-10-22
# author  : clibing
# email   : wmsjhappy@gmail.com


nginx_home=${nginx_home:-"/usr/local/nginx"}
keep_days=${keep_days:-"7"}

while getopts "h:d:" OPT; do
    case $OPT in
        h)
            nginx_home=$OPTARG;;
        d)
            keep_days=$OPTARG;;
    esac
done

nginx_conf=${nginx_home}/conf
nginx_logrotate=${nginx_conf}/logrotate.conf
nginx_logs=${nginx_home}/logs

if [ ! -d "${nginx_conf}" ]; then
    mkdir -p "${nginx_conf}"
fi

cat >${nginx_logrotate} <<EOF
${nginx_logs}/*.log {
    daily
    dateext
    missingok
    rotate ${keep_days}
    compress
    delaycompress
    notifempty
    sharedscripts
    postrotate
        if [ -f ${nginx_logs}/nginx.pid ]; then
          kill -USR1 \`cat ${nginx_logs}/nginx.pid\`
        fi
    endscript
}
EOF

echo -e "add contab line\n59 23 * * * /usr/sbin/logrotate -f ${nginx_logrotate}"
