Puppet Server Configuration
==================

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
