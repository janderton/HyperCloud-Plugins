HyperCloud-Plugins
==================

This repository is meant to house all HyperCloud Plugin examples.  All Plugin files in this repository are in the HyperCloud export format.  You can simply import these into HyperCloud to create new Plugins.

Plugins can be packaged together with Blueprints in the YAML, and run with the lifecycle parameter for various pre and post executions.  This can be done for single or multi-container based applications, or single or multi-VM based applications.

Plugins can also be run against an actively running single or multi-tier application for various activities such as injecting code, loading software, application or system configuration, and other processes.


### Clone this project

You can clone this project:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
git clone https://github.com/hypergrid-inc/HyperCloud-Plugins.git
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Plugin Listing

### Nginx Setup

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


### Deploy Java War File

Deploys WAR file into tomcat webapps folder

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#!/bin/bash

sleep 10;
rm -rf $delete_dir
curl -L -o $dir $file_url

dir=/usr/local/tomcat/webapps/ROOT.war
file_name=plugindefault
delete_dir=/usr/local/tomcat/webapps/ROOT
file_url=https://github.com/dchqinc/dchq-docker-java-example/raw/master/dbconnect.war
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### AWS List S3 Buckets

Generates a listing of S3 buckets for a given region, key, and secret key

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#!/bin/bash

apt-get update -y
apt-get install python3.6 -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
pip install awscli

sudo mkdir ~/.aws
echo [default] > config
echo aws_access_key_id=<ACCESS_KEY> >> config
echo aws_secret_access_key=<SECRET_KEY> >> config
echo region=us-west-2 >> config
mv config ~/.aws

aws s3 ls
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Blueprint Provision Plugin

Have your plugin call other plugins via the API. You can use this within an Ubuntu/Debian container blueprint and call it several times, serially, for each desired Blueprint or execute this as a post build process on an Ubuntu/Debian host for cascading Blueprints.

```
#!/bin/bash

# Use this blueprint on Ubuntu Linux Images to provision subsequent blueprints (cascading) or use an Ubuntu container to run multiple blueprint builds from a single master blueprint

apt update && apt install -y curl jq

curl -sk --user $user:$token -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"blueprint":"$blueprintId","cloudProvider":"$cloudProvider","resourcePool":"$resourcePool","cluster":null,"params":[],"terminationProtection":"DISABLED","skipAgentInstall":"true"}' "$url/api/dockerservers/sdi" | jq '.'
```
