# main.tf

provider "digitalocean" {
  token = "${var.do_token}"
}

module "server-droplet" {
  source = "./modules/server-droplet"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  server_count = "1"
}

module "client-droplet" {
  source = "./modules/client-droplet"
  ssh_fingerprint = "${var.ssh_fingerprint}"
  client_count = "1"
  consul_server_ip = "${module.server-droplet.consul_server_ip}"
}

module "load-balancer" {
  source = "./modules/load-balancer"
  server_ids = "${list("${module.server-droplet.server_id}", "${module.client-droplet.client_id}")}"
}

module "firewall" {
  source = "./modules/firewall"
  server_ids = "${list("${module.server-droplet.server_id}", "${module.client-droplet.client_id}")}"
  load_balancer_id = "${module.load-balancer.load_balancer_id}"
  bastion_id = "${var.bastion_host_id}"
}
