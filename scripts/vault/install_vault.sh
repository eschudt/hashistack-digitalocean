#! /bin/bash

echo "Installing Vault on server\n"

# Start install of vault
wget https://releases.hashicorp.com/vault/0.11.1/vault_0.11.1_linux_amd64.zip
unzip vault_0.11.1_linux_amd64.zip
cp vault /usr/bin/

# Start vault as a service
systemctl enable vault-server.service
systemctl start vault-server.service

echo "Installation of Vault complete\n"
exit 0
