# modules/client-droplet/main.tf
# Create droplets and install consul and nomad in client mode

variable "ssh_fingerprint" {
  description = "SSH fingerprint to enable"
}

variable "client_count" {
  description = "Number of clients to create"
}

variable "consul_server_ip" {
  description = "The ip address of a consul server"
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "client1" {
  count              = "${var.client_count}"
  name               = "client-${count.index + 1}"
  image              = "ubuntu-16-04-x64"
  region             = "lon1"
  size               = "512mb"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/client/client2.hcl"
    destination = "/root/client2.hcl"

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
    }
  }

  provisioner "file" {
    source      = "${path.root}/scripts/consul/install_consul.sh"
    destination = "/tmp/install_consul.sh"

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
    }
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/install_nomad.sh"
    destination = "/tmp/install_nomad.sh"

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_consul.sh",
      # "/tmp/install_consul.sh client ${self.ipv4_address_private} ${var.consul_server_ip}",
    ]

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_nomad.sh",
      "/tmp/install_nomad.sh client",
    ]

    connection {
      type         = "ssh"
      user         = "root"
      host         = "${self.ipv4_address}"
    }
  }

}
