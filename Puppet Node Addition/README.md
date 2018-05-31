Puppet Node Addition
==================

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



