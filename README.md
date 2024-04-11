# Keep your webserver behind Nginx clean from RKN bots.

This project uses blacklists from https://github.com/C24Be/AS_Network_List/blob/main/blacklists/blacklist.txt

## How to use

Clone this repo to your server and run ./generateConf.sh

Then you see something like this: 

```
Add this block into the main Nginx config (usually resides in /etc/nginx/nginx.conf):

	include /home/<username>/nginx-rugov-block/conf/nginx.http.conf;

Usually, putting this into a separate conf file in /etc/nginx/conf.d/rugov.conf should be enough. Run to achieve this: 

	echo 'include /home/<username>/nginx-rugov-block/conf/nginx.http.conf;' | sudo tee /etc/nginx/conf.d/rugov.conf

Add this directive to every server block you want to protect:

	if ($fmt_rugov = "RUGOV" ) { return 499; }

Alernatively, you can include this directive into every server block using:

	include /home/<username>/nginx-rugov-block/conf/nginx.server.conf;

Next steps are:
 - reloag nginx (nginx -s reload)
 - periodically update blacklists using '/home/<username>/nginx-rugov-block/updateBlocklist.sh --restart'

You can achieve cron auto update by symlinking the update script to cron.daily:

sudo ln -s /home/<username>/nginx-rugov-block/updateBlocklist.sh /etc/cron.daily/rugov_nginx_updater.sh
```

Do all the steps carefully and you are done! 

P.S. Don't forget to update lists!
