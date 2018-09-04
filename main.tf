# main.tf

provider "digitalocean" {
  token = "${var.do_token}"
}

#module "bastion_host" {
#  source = "./modules/bastion_host"
#  ssh_fingerprint = "${var.ssh_fingerprint}"
#}

module "server-droplet" {
  source = "./modules/server-droplet"
  #bastion_host = "${module.bastion_host.bastion_host_ip}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  server_count = "1"
}

module "client-droplet" {
  source = "./modules/client-droplet"
  #bastion_host = "${module.bastion_host.bastion_host_ip}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  client_count = "1"
  consul_server_ip = ${module.server.consul_server_ip}
}
