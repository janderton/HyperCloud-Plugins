Deploy Java WAR File
==================

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


