# modules/bastion_host/main.tf
# Create the bastion_host with floating ip to receive all requests

variable "ssh_fingerprint" {
  description = "SSH fingerprint to enable"
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "bastion-host" {
  image  = "ubuntu-16-04-x64"
  name   = "bastion-host"
  region = "lon1"
  size   = "512mb"
  private_networking = false
  ssh_keys = ["${var.ssh_fingerprint}"]
}

# Create a static ip to access from public
resource "digitalocean_floating_ip" "bastion-host" {
  droplet_id = "${digitalocean_droplet.bastion-host.id}"
  region     = "${digitalocean_droplet.bastion-host.region}"
}
output "bastion_host_ip" {
  value = "${digitalocean_floating_ip.bastion-host.ip_address}"
}
