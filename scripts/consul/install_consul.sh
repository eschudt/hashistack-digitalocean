#! /bin/bash
echo "Installing Consul on server\n"
apt install --yes unzip
wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
unzip consul_1.2.1_linux_amd64.zip
cp consul /usr/bin/
#if [ $1 == "server" ]; then
#	consul agent -server -enable-script-checks=true
#else
#	consul join $2
#fi
echo "Installation of Consul complete\n"
exit 0
