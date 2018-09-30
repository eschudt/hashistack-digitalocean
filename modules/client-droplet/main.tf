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

variable "server_ids" {
  type = "list"
  description = "list of servers"
}

#null resource to ensure dependency of server module
resource "null_resource" "dependency_manager" {
  triggers {
    dependency_id = ["${var.server_ids}"]
  }
}

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "client" {
  count              = "${var.client_count}"
  name               = "client-${count.index + 1}"
  image              = "ubuntu-18-04-x64"
  region             = "lon1"
  size               = "512mb"
  private_networking = true
  ssh_keys = ["${var.ssh_fingerprint}"]

  depends_on = ["null_resource.dependency_manager"]

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
    source      = "${path.root}/scripts/consul/consul-client.service"
    destination = "/etc/systemd/system/consul-client.service"
  }


  # Nomad files
  provisioner "file" {
    source      = "${path.root}/scripts/nomad/client/client.hcl"
    destination = "/root/client.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/install_nomad.sh"
    destination = "/tmp/install_nomad.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/nomad/client/nomad-client.service"
    destination = "/etc/systemd/system/nomad-client.service"
  }

  # Run commands
  # Install Consul
  provisioner "remote-exec" {
    inline = [
      "sed -i 's/count/${count.index + 1}/g' /etc/systemd/system/consul-client.service",
      "chmod +x /tmp/install_consul.sh",
      "/tmp/install_consul.sh client ${self.ipv4_address_private} ${var.consul_server_ip}",
    ]
  }

  # Install Nomad
  provisioner "remote-exec" {
    inline = [
      "sed -i 's/countIndex/${count.index + 1}/g' /etc/systemd/system/nomad-client.service",
      "chmod +x /tmp/install_nomad.sh",
      "/tmp/install_nomad.sh client",
    ]
  }

}

output "client_ids" {
  value = "${digitalocean_droplet.client.*.id}"
}
