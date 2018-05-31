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
### Puppet Server App Deployment Blueprint

The Blueprint can be used to deploy the containerized Puppet Server and install the nginx and mysql modules onto it to with some initial node definations created that configures the nginx and mysql on the defined nodes.
It executes a plugin immediately after the container deployment which install the modules and creates initial node definations.

```
puppet:
  image: puppet/puppetserver-standalone
  name: puppethc 
  hostname: puppethc
  ports:
  - 8140:8140
  plugins:
  - !plugin
    id: JCiLs
    arguments:
      - modules=puppet-nginx puppetlabs-mysql
      - nodes= <Enter space separated FQDN of nodes here>
```
### Puppet Server Node Addition Plugin

You can have multiple node definations to be added later after the Puppet Server deployment using the Node Addition Plugin and providing the space separated node list as argument to it.

```
nodes="space separated Node Names"
array=(`echo "$nodes"`)

for node in "${array[@]}"
do
  echo "###Node Defination for $node.

node '$node'{

  class { 'nginx': }
  class { '::mysql::server':
  root_password           => 'HyperGrid123',
  remove_default_accounts => true,
  override_options        => \$override_options
  }

}" >> /etc/puppetlabs/code/environments/production/manifests/nodes.pp
done
```

### Puppet Server Module Installation Plugin

You can add multiple modules on a Puppet Server after the deployment so that these modules can be pushed to the nodes using node definations. You can use the Modules Installation Plugin providing the space separated list of the module names as they are in puppet forge.

```
modules="space separated list of mudule names"
array=(`echo "$modules"`)
for module in "${array[@]}"
do
  echo "Installing $module module"
  puppet module install $module
done
```

### Puppet Agent Installation Plugin

You can install puppet agent on a node and make it a part of a Puppet Server from where it will pick up the configurations using the Puppet Agent Installation Plugin and provide the Puppet Server FQDN and it's IP as argument.

```
#!/bin/bash
PUPPET_SERVER_FQDN="puppethc"
PUPPET_SERVER_IP="10.100.12.99"
OS_T=`ls /etc | grep -e "_version$"`
echo "OS is: $OS_T"

if [ ! -z "$OS_T" ]
then
  VERSION=`cat /etc/issue.net | grep -e "^Ubuntu 14.04"`
  echo "Debian version is: $VERSION"
  if [ ! -z "$VERSION" ]
  then
    echo "Starting code to install puppet on Ubuntu14.04"
    wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
    dpkg -i puppet5-release-trusty.deb
    apt-get update
    apt-get install puppet-agent -y
  fi
  VERSION=`cat /etc/issue.net | grep -e "^Ubuntu 16.04"`
  echo "Debian version is: $VERSION"
  if [ ! -z "$VERSION" ]
  then
    echo "Starting code to install puppet on Ubuntu16.04"
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    dpkg -i puppet5-release-xenial.deb
    apt update
	apt install puppet-agent -y
  fi
fi
OS_T=`ls /etc | grep -e "^centos-release$"`
if [ ! -z "$OS_T" ]
then
  VERSION=`cat /etc/centos-release  | grep -e "^CentOS Linux release 7"`
  echo "CentOS version is: $VERSION"
  if [ ! -z "$VERSION" ]
  then 
    echo "Starting code to install puppet on CENTOS 7"
	rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
	yum install puppet-agent -y
  fi
  
fi
echo "$PUPPET_SERVER_IP    $PUPPET_SERVER_FQDN" >>/etc/hosts
/opt/puppetlabs/bin/puppet config set server $PUPPET_SERVER_FQDN
```


