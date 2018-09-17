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
  image              = "ubuntu-18-04-x64"
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

  # Copy files to remote server
  # Consul files
  provisioner "file" {
    source      = "${path.root}/scripts/consul/install_consul.sh"
    destination = "/tmp/install_consul.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/consul/consul-server.service"
    destination = "/etc/systemd/system/consul-server.service"
  }

  # Nomad files
  provisioner "file" {
    source      = "${path.root}/scripts/nomad/server/server.hcl"
    destination = "/root/server.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/client/client.hcl"
    destination = "/root/client.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/install_nomad.sh"
    destination = "/tmp/install_nomad.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/server/nomad-server.service"
    destination = "/etc/systemd/system/nomad-server.service"
  }

  # Nomad job files
  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/fabio.ctmpl"
    destination = "/root/fabio.ctmpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/age-generator.ctmpl"
    destination = "/root/age-generator.ctmpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/name-generator.ctmpl"
    destination = "/root/name-generator.ctmpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/startJob.sh"
    destination = "/root/startJob.sh"
  }

  # Vault files
  provisioner "file" {
    source      = "${path.root}/scripts/vault/vault-config.hcl"
    destination = "/root/vault-config.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/vault/vault-server.service"
    destination = "/etc/systemd/system/vault-server.service"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/vault/install_vault.sh"
    destination = "/tmp/install_vault.sh"
  }

  # Run commands
  # Install Consul
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_consul.sh",
      "/tmp/install_consul.sh server ${self.ipv4_address_private}",
    ]
  }

  # Install Vault
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_vault.sh",
      "sed -i 's/server_ip/${self.ipv4_address_private}/g' /root/vault-config.hcl",
      "/tmp/install_vault server",
      ]
    }

  # Install Nomad
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/startJob.sh",
      "chmod +x /tmp/install_nomad.sh",
      "sed -i 's/server_ip/${self.ipv4_address_private}/g' /root/server.hcl",
      "/tmp/install_nomad.sh server",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${digitalocean_droplet.server.0.ipv4_address_private} > /root/private_server.txt"
  }

  provisioner "local-exec" {
    command = "echo ${digitalocean_droplet.server.0.ipv4_address} > /root/public_server.txt"
  }
}

output "consul_server_ip" {
  value = "${digitalocean_droplet.server.0.ipv4_address_private}"
}

output "server_id" {
  value = "${digitalocean_droplet.server.0.id}"
}
