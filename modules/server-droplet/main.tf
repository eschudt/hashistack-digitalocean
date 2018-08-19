# modules/server-droplet/main.tf
# Create droplets and install consul and nomad in server mode

variable "ssh_fingerprint" {
  description = "SSH fingerprint to enable"
}

variable "server_count" {
  description = "Number of servers to create"
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "server1" {
  count              = "${var.server_count}"
  name               = "server-${count.index + 1}"
  image              = "ubuntu-16-04-x64"
  region             = "lon1"
  size               = "512mb"
  private_networking = false
  ssh_keys = ["${var.ssh_fingerprint}"]

  provisioner "remote-exec" {
    scripts = [
      "${path.root}/scripts/consul/install_consul.sh",
      "${path.root}/scripts/nomad/install_nomad.sh",
    ]

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
      #bastion_host = "${var.bastion_host}"
      #bastion_user = "root"
      #agent        = true
    }
  }
}
