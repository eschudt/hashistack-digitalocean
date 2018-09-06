#! /bin/bash
echo "Installing Consul on server\n"
apt install --yes unzip
apt-get install --yes docker-ce
wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
unzip consul_1.2.1_linux_amd64.zip
cp consul /usr/bin/
mkdir /etc/consul.d
mkdir /tmp/consul
if [ $1 == "server" ]; then
	consul agent -server -bootstrap-expect=1 -data-dir=/tmp/consul -node=agent-one -bind=$2 -enable-script-checks=true -config-dir=/etc/consul.d &
else
  consul agent -data-dir=/tmp/consul -node=agent-two -bind=$2 -enable-script-checks=true -config-dir=/etc/consul.d &
  sleep 5
	consul join $3
fi
echo "Installation of Consul complete\n"
exit 0
