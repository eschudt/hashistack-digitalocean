#! /bin/bash

jobName=$1
buildVersion=$2
serviceCount=$3

# Get nomad server ip from private eth1
# Ubuntu 16 use the command below
#nomadIp=`/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
# Ubuntu 18 use the command below
nomadIp=`/sbin/ifconfig eth1 | grep 'inet ' | sed 's/\s\s*/ /g' | cut -d" " -f3 | awk '{ print $1}'`

export NOMAD_ADDR="http://${nomadIp}:4646"

# Put buildVersion and count in consul kv store
consul kv put "${jobName}-version" ${buildVersion}
consul kv put "${jobName}-count" ${serviceCount}

# Generate the .nomad file using consul-template
consul-template -template "/root/${jobName}.ctmpl:/root/${jobName}.nomad:nomad job run /root/${jobName}.nomad" -once

exit 0
