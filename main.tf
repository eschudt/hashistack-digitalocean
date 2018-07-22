# main.tf

variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

module "gateway" {
  source = "./modules/gateway"
}

module "servers" {
  source = "./modules/servers"
}
