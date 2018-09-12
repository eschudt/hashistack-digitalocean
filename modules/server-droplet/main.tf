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
    source      = "${path.root}/scripts/nomad/client/client.hcl"
    destination = "/root/client.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/fabio.tpl"
    destination = "/root/fabio.tpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/age-generator.tpl"
    destination = "/root/age-generator.tpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/name-generator.tpl"
    destination = "/root/name-generator.tpl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/consul/install_consul.sh"
    destination = "/tmp/install_consul.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/install_nomad.sh"
    destination = "/tmp/install_nomad.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/server/nomad-server.service"
    destination = "/etc/systemd/system/nomad-server.service"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/consul/consul-server.service"
    destination = "/etc/systemd/system/consul-server.service"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/jobs/startJob.sh"
    destination = "/root/startJob.sh"
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
