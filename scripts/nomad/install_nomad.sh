#! /bin/bash
echo "Installing Nomad on server\n"
apt-get update
apt install --yes docker.io
wget https://releases.hashicorp.com/nomad/0.8.4/nomad_0.8.4_linux_amd64.zip
unzip nomad_0.8.4_linux_amd64.zip
cp nomad /usr/bin/
if [ $1 == "server" ]; then
	systemctl enable nomad-server.service
	systemctl start nomad-server.service
	#nomad agent -config server.hcl nomad-server.log 2>&1 &
  #sleep 5
  #nomad agent -config client1.hcl &
else
	systemctl enable nomad-client.service
	systemctl start nomad-client.service
	#nomad agent -config client2.hcl nomad-client.log 2>&1 &
fi
echo "Installation of Nomad complete\n"
exit 0
