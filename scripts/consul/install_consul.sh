#! /bin/bash
echo "Installing Consul on server\n"
apt-get update
apt install --yes unzip
apt install --yes docker.io
wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
unzip consul_1.2.1_linux_amd64.zip
cp consul /usr/bin/
mkdir /etc/consul.d
mkdir /tmp/consul

if [ $1 == "server" ]; then
	systemctl enable consul-server.service
	systemctl start consul-server.service
	#consul agent -server -bootstrap-expect=1 -data-dir=/tmp/consul -node=agent-one -bind=$2 -enable-script-checks=true -config-dir=/etc/consul.d &
else
	systemctl enable consul-client.service
	systemctl start consul-client.service
  #consul agent -data-dir=/tmp/consul -node=agent-two -bind=$2 -enable-script-checks=true -config-dir=/etc/consul.d &
  sleep 5
	consul join $3
fi
echo "Installation of Consul complete\n"
exit 0
