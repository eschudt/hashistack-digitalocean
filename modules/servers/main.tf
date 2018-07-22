# modules/servers/main.tf
# Create 1 server and install consul, nomad, docker

# Create a new Web Droplet in the fra1 region
resource "digitalocean_droplet" "server1" {
  image  = "ubuntu-16-04.4-x64"
  name   = "server1"
  region = "fra1"
  size   = "512mb"

  provisioner "remote-exec" {
    scripts = [
      "${path.root}/scripts/consul/install_consul.sh",
      "${path.root}/scripts/nomad/install_nomad.sh",
      "${path.root}/scripts/docker/install_docker.sh",
    ]
  }
}
