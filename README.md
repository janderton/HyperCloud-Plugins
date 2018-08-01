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

__[Nginx Setup](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Nginx%20Setup)__

### Deploy Java War File

Deploys WAR file into tomcat webapps folder

__[Deploy Java War File](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Deploy%20Java%20WAR%20File)__

### AWS List S3 Buckets

Generates a listing of S3 buckets for a given region, key, and secret key

__[AWS List S3 Buckets Plugin](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/AWS%20List%20S3%20Buckets)__

### Blueprint Provision Plugin

Have your plugin call other plugins via the API. You can use this within an Ubuntu/Debian container blueprint and call it several times, serially, for each desired Blueprint or execute this as a post build process on an Ubuntu/Debian host for cascading Blueprints.

__[Ubuntu Utility Blueprint and/or Container Deployment](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Ubuntu%20Utility%20Blueprint%20and:or%20Container%20Deployment)__

### Puppet Server App Deployment Blueprint

The Blueprint can be used to deploy the containerized Puppet Server and install the nginx and mysql modules onto it to with some initial node definations created that configures the nginx and mysql on the defined nodes.
It executes a plugin immediately after the container deployment which install the modules and creates initial node definations.

__[Puppet Server Configuration](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Puppet%20Server%20Configuration)__

### Puppet Server Node Addition Plugin

You can have multiple node definations to be added later after the Puppet Server deployment using the Node Addition Plugin and providing the space separated node list as argument to it.

__[Puppet Node Addition](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Puppet%20Node%20Addition)__

### Puppet Server Module Installation Plugin

You can add multiple modules on a Puppet Server after the deployment so that these modules can be pushed to the nodes using node definations. You can use the Modules Installation Plugin providing the space separated list of the module names as they are in puppet forge.

__[Puppet Module Install](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Puppet%20Module%20Install)__

### Puppet Agent Installation Plugin

You can install puppet agent on a node and make it a part of a Puppet Server from where it will pick up the configurations using the Puppet Agent Installation Plugin and provide the Puppet Server FQDN and it's IP as argument.

__[Puppet Agent Install](https://github.com/hypergrid-inc/HyperCloud-Plugins/tree/master/Puppet%20Agent%20Install)__


### Chef Server Install and Initial Configuration

This plugin installs the Chef server, Chef Mnagement Server and the Chef DK on the Ubuntu server and does the initial configuration related to cookbooks and recipes. This plugin adds the recipes for pushing jenkins, nginx and potgresql on the respective nodes.
It requests for 3 arguments which are :
  1) ORGNAME, it should be as string with no special charaters and should reperesent the Organization Name for the configuraiton managment.
  2) CHEFSERVERURL, it is the URL for downloading the chef server installation file for ubuntu16 and might need updation with the changing stable version of Chef Server.
  3) CHEFDKURL, it is the URL for downloading the chefdk installation file for ubuntu16 and might need updation with the changing stable version of ChefDK.


### Chef Node Add

This plugin installs chef client on the nodes specified and add the jenkins, nginx and postgresql installaton recipes to the node's run list so that when you give the command chef-client on the node it will pull the configurations from Chef Server and will install jenkins, nginx and postgresql on the node.
This plugin takes a space separated list of the node details and node details consists of comma separated information about node like IP,nodename,username,password. These are required to install the chef client software on the nodes and build a secure communication. One example of the list of nodes is as below:
10.0.9.100,node1,hc,HyperGrid123 10.0.9.200,node2,hc,HyperGrid123
