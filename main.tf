# main.tf

provider "digitalocean" {
  token = "${var.do_token}"
}

module "bastion_host" {
  source = "./modules/bastion_host"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

module "consul" {
  source = "./modules/consul"
  bastion_host = "${module.bastion_host.bastion_host_ip}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}
