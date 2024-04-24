#!/bin/bash -e
set -euo pipefail
IFS=$'\n\t'

export FMT_DIR=$(dirname $(readlink -f $0))

if [ ! -f "${FMT_DIR}/conf/rugov.map.conf" ]; then
	echo "Updating blacklist map..."
	${FMT_DIR}/updateBlocklist.sh
fi

FMTD='$' envsubst < "${FMT_DIR}/nginx.http.tpl" > "${FMT_DIR}/conf/nginx.http.conf"
cp -f "${FMT_DIR}/nginx.server.tpl" "${FMT_DIR}/conf/nginx.server.conf"

echo "Add this block into the main Nginx config (usually resides in /etc/nginx/nginx.conf):"
echo
echo "	include ${FMT_DIR}/conf/nginx.http.conf;"
echo
echo "Usually, putting this into a separate conf file in /etc/nginx/conf.d/rugov.conf should be enough. Run to achieve this: "
echo
echo "		echo 'include ${FMT_DIR}/conf/nginx.http.conf;' | sudo tee /etc/nginx/conf.d/rugov.conf"
echo 
echo "Add this directive to every server block you want to protect:"
echo 
echo '	if ($fmt_rugov = "RUGOV" ) { return 499; }'
echo
echo "Alternatively, you can include this directive into every server block using:"
echo
echo "	include ${FMT_DIR}/conf/nginx.server.conf;"
echo 
echo "The next steps are:"
echo " - reload nginx (nginx -s reload)"
echo " - periodically update blacklists using '${FMT_DIR}/updateBlocklist.sh --restart'"
echo
echo "You can achieve cron auto update by symlinking the update script to cron.daily:"
echo
echo "sudo ln -s ${FMT_DIR}/updateBlocklist.sh /etc/cron.daily/rugov_nginx_updater"
