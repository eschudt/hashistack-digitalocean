# modules/consul/main.tf
# Create 2 servers and install consul

variable "bastion_host" {
  description = "IP of bastion host used for provisioning"
}

# Create a new Web Droplet in the fra1 region
resource "digitalocean_droplet" "server1" {
  image              = "ubuntu-16-04-x64"
  name               = "server1"
  region             = "fra1"
  size               = "512mb"
  private_networking = true

  provisioner "remote-exec" {
    scripts = [
      "${path.root}/scripts/consul/install_consul.sh"
    ]

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address_private}"
      bastion_host = "${var.bastion_host}"
      bastion_user = "root"
      agent        = true
    }
  }
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "server2" {
image              = "ubuntu-16-04-x64"
name               = "server2"
region             = "lon1"
size               = "512mb"
private_networking = true

  provisioner "remote-exec" {
    scripts = [
      "${path.root}/scripts/consul/install_consul.sh"
    ]

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address_private}"
      bastion_host = "${var.bastion_host}"
      bastion_user = "root"
      agent        = true
    }
  }
}
