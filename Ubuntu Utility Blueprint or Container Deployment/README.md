Ubuntu Utility Blueprint and/or Container Deployment
==================

Have your plugin call other plugins via the API. You can use this within an Ubuntu/Debian container blueprint and call it several times, serially, for each desired Blueprint or execute this as a post build process on an Ubuntu/Debian host for cascading Blueprints.

```
#!/bin/bash

# Use this blueprint on Ubuntu Linux Images to provision subsequent blueprints (cascading) or use an Ubuntu container to run multiple blueprint builds from a single master blueprint

apt update && apt install -y curl jq

curl -sk --user $user:$token -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"blueprint":"$blueprintId","cloudProvider":"$cloudProvider","resourcePool":"$resourcePool","cluster":null,"params":[],"terminationProtection":"DISABLED","skipAgentInstall":"true"}' "$url/api/dockerservers/sdi" | jq '.'
```
