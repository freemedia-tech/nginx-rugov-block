#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

FMTDIR=$(dirname $(readlink -f $0))
curl --silent "https://raw.githubusercontent.com/C24Be/AS_Network_List/main/blacklists/blacklist.txt" | while read line; do echo "${line} RUGOV;"; done > "$FMTDIR/conf/rugov.map.conf"

if [ -z ${1+x} ]; then
	exit
fi

if [ "$1" == "--restart" ];then
	FMT_NGINX=$(type -t nginx || echo "")
	if [ "$FMT_NGINX" == "" ]; then
		echo "Nginx not found. Do the restart yourself! Run 'nginx -s reload'"
		exit
	fi
	nginx -t
	nginx -s reload
fi
