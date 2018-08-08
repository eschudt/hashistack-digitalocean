#! /bin/bash
echo "Installing Consul on server\n"
apt install unzip
wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
unzip consul_1.2.1_linux_amd64.zip
cp consul /usr/bin/
echo "Installation of Consul complete\n"
