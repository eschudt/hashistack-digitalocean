# modules/bastion_host/main.tf
# Create the bastion_host with floating ip to receive all requests

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "bastion_host" {
  image  = "ubuntu-16-04-x64"
  name   = "bastion_host"
  region = "lon1"
  size   = "512mb"
  private_networking = false
  tags = ["bastion_host"]
}

# Create a static ip to access from public
resource "digitalocean_floating_ip" "bastion_host" {
  droplet_id = "${digitalocean_droplet.bastion_host.id}"
  region     = "${digitalocean_droplet.bastion_host.region}"
}
output "bastion_host_ip" {
  value = "${digitalocean_floating_ip.bastion_host.ip_address}"
}
