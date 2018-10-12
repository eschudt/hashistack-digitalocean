#! /bin/bash

echo "Installing Nomad on server\n"

# Install nomad
wget https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip
unzip nomad_0.8.6_linux_amd64.zip
cp nomad /usr/bin/

# Setup Vault Token
vaultToken=`grep "Initial Root Token" /root/startupOutput.txt | cut -d' ' -f4`
sed -i 's/replace_vault_token/${vaultToken}/g' /etc/systemd/system/vault-server.service

# Start nomad as a service
if [ $1 == "server" ]; then
	systemctl enable nomad-server.service
	systemctl start nomad-server.service
else
	systemctl enable nomad-client.service
	systemctl start nomad-client.service
fi
echo "Installation of Nomad complete\n"
exit 0
