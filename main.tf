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

module "nomad-jobs" {
  source = "./modules/nomad-jobs"
  nomad_server_ip = "${module.client-droplet.nomad_server_ip}"
}
