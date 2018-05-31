Puppet Agent Install
==================

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


