#! /bin/bash

echo "Setting Up Vault on Server\n"
# init vautl, unseal vault and export root token
export VAULT_ADDR=http://127.0.0.1:8200

if [ $1 == "0" ]; then
	vault operator init -address=http://127.0.0.1:8200 > /root/startupOutput.txt

	vault operator unseal -address=http://127.0.0.1:8200 `grep "Unseal Key 1" /root/startupOutput.txt | cut -d' ' -f4`
	vault operator unseal -address=http://127.0.0.1:8200 `grep "Unseal Key 2" /root/startupOutput.txt | cut -d' ' -f4`
	vault operator unseal -address=http://127.0.0.1:8200 `grep "Unseal Key 3" /root/startupOutput.txt | cut -d' ' -f4`
fi

echo "Setup of Vault Complete\n"
exit 0
