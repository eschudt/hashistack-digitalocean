# modules/gateway/main.tf
# Create the gateway with public ip to receive all requests
# Install consul, nomad, docker

# Create a new Web Droplet in the lon1 region
resource "digitalocean_droplet" "gateway" {
  image  = "ubuntu-16-04.4-x64"
  name   = "gateway"
  region = "lon1"
  size   = "512mb"

  provisioner "remote-exec" {
    scripts = [
      "${path.root}/scripts/consul/install_consul.sh",
      "${path.root}/scripts/nomad/install_nomad.sh",
      "${path.root}/scripts/docker/install_docker.sh",
    ]
  }
}

# Create a static ip to access from public
resource "digitalocean_floating_ip" "gateway" {
  droplet_id = "${digitalocean_droplet.gateway.id}"
  region     = "${digitalocean_droplet.gateway.region}"
}
output "public_ip" {
  value = "${digitalocean_droplet.gateway.ip}"
}
