Puppet Module Install
==================

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


