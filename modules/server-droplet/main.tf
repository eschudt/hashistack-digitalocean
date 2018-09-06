# modules/server-droplet/main.tf
# Create droplets and install consul and nomad in server mode

variable "ssh_fingerprint" {
  description = "SSH fingerprint to enable"
}

variable "server_count" {
  description = "Number of servers to create"
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "server" {
  count              = "${var.server_count}"
  name               = "server-${count.index + 1}"
  image              = "ubuntu-16-04-x64"
  region             = "lon1"
  size               = "512mb"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]

  connection {
    type         = "ssh"
    user         = "root"
    host         = "${self.ipv4_address}"
    agent        = true
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/server/server.hcl"
    destination = "/root/server.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/client/client1.hcl"
    destination = "/root/client1.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/fabio.nomad"
    destination = "/root/fabio.nomad"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/age-generator.nomad"
    destination = "/root/age-generator.nomad"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/name-generator.nomad"
    destination = "/root/name-generator.nomad"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/consul/install_consul.sh"
    destination = "/tmp/install_consul.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/install_nomad.sh"
    destination = "/tmp/install_nomad.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_consul.sh",
      "/tmp/install_consul.sh server ${self.ipv4_address_private}",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_nomad.sh",
      "sed -i 's/server_ip/${self.ipv4_address_private}/g' /root/server.hcl",
      "/tmp/install_nomad.sh server",
    ]
  }
}

output "consul_server_ip" {
  value = "${digitalocean_droplet.server.0.ipv4_address_private}"
}
