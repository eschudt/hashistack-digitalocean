# Hashistack Digitalocean
Terraform to setup a consul and nomad cluster by building the number of servers and clients specified.
It wraps them around a firewall that can only be accesses via a bastion host (ssh) and a load balancer (http)
Uses digital ocean as a provider to create the droplets needed.

It starts nomad and consul as a service and automatically connects all nodes in the cluster

## Environment variables
* `do_token` - api token for digital ocean which can be found in your DigitalOcean Account under "API"
* `ssh_fingerprint` - the ssh fingerprint to use to connect to your newly created droplets
* `bastion_host_id` - the droplet id of the bastion host server
* `server_count` - number of server droplets to create
* `client_count` - number of client droplets to create

## Modules
### server-droplet
* Create servers and sets up nomad and consul in server mode
* `server_count` - number of server droplets to create

### client-droplet
* Create clients and sets up nomad and consul in client mode
* `client_count` - number of client droplets to create
* `consul_server_ip` - a consul server ip

### load-balancer
* Create a public load balancer to connect to all servers
* `all_server_ids` - ids of all servers (droplets)

### firewall
* Create a firewall around the server and client droplets
* `all_server_ids` - ids of all servers (droplets)
* `load_balancer_id` - the id of the digital ocean load balancer
* `bastion_id` - the droplet id of the bastion host

## Scripts
Scripts for installing required software in newly created droplets

### consul
`install_consul.sh client|server ${self.ipv4_address_private} ${var.consul_server_ip}`
* Installs required software - unzip and docker
* Sets up iptables to allow access to localhost from docker
* Downloads consul and copies the binary to the /user/bin directory
* Starts consul as a service in either server or client mode
* If in client mode, it joins the client to the cluster

### nomad
`install_nomad.sh client|server`
* Downloads nomad and copies the binary to the /user/bin directory
* Starts nomad as a service in either server or client mode

### vault
`install_vault.sh server`
* Downloads vault and copies the binary to the /user/bin directory
* Starts vault as a service in server mode
* Initializes Vault
* Unseals vaults to make it ready for use
* Exports the vault token for nomad to use

## How to run
* ``eval `ssh-agent -s` ``
* `ssh-add ~/.ssh/id_rsa` (add your private key to the ssh agent which corresponds to the ssh_fingerprint)
* `terraform init`
* `terraform plan`
* `terraform apply`
