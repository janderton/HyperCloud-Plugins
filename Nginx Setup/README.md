Nginx Setup
==================

Performs initial configuration and setup of Nginx

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#!/bin/bash

sleep 1

config=/etc/nginx/conf.d/default.conf
# delete all config
rm -f $config
IN='$servers'
IFS=',' read -ra ADDR <<< "$IN"
for i in "${ADDR[@]}"; do
    x=$x$i\\n
done

FILECONTENT_1="
upstream backend_hosts {
	#server 172.17.10.128;
"

FILECONTENT_2=$x

FILECONTENT_3="
}

server {
listen       80;
server_name  localhost;

	location / {
		proxy_set_header X-Forwarded-Host \$host;
		proxy_set_header X-Forwarded-Server \$host;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_pass http://backend_hosts/;
	}
}
"

FILECONTENT=$FILECONTENT_1$FILECONTENT_2$FILECONTENT_3

echo -e "$FILECONTENT" > $config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

