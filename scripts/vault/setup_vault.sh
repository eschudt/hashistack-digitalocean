#! /bin/bash

echo "Setting Up Vault on Server\n"
# init vautl, unseal vault and export root token

if [ $1 == "0" ]; then
	vault operator init > startupOutput.txt

	vault operator unseal `grep "Unseal Key 1" startupOutput.txt | cut -d' ' -f4`
	vault operator unseal `grep "Unseal Key 2" startupOutput.txt | cut -d' ' -f4`
	vault operator unseal `grep "Unseal Key 3" startupOutput.txt | cut -d' ' -f4`

	export VAULT_TOKEN=`grep "Initial Root Token" startupOutput.txt | cut -d' ' -f4`
fi

echo "Setup of Vault Complete\n"
exit 0
