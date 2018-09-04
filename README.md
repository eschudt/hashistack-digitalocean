# terra-nomad-consul
Terraform to setup a consul and nomad cluster by building the number of servers and clients specified.
Uses digital ocean as a provider to create the droplets needed.

## Environment variables
* `do_token` - api token for digital ocean which can be found in your DigitalOcean Account under "API"
* `ssh_fingerprint` - the ssh fingerprint to use to connect to your newly created droplets

## Modules
### client-droplet
* Create clients and sets up nomand and consul in client mode (TODO instantiating in client mode)
* `client_count` - number of client droplets to create
* `consul_server_ip` - a consul server ip

### server-droplet
* Create servers and sets up nomand and consul in server mode (TODO instantiating in server mode)
* `server_count` - number of server droplets to create

## Scripts
Scripts for installing required software in newly created droplets

### consul
Downloads consul and copies the binary to the /user/bin directory

### nomad
Downloads nomad and copies the binary to the /user/bin directory

## How to run
* terraform init
* terraform plan
* terraform apply
