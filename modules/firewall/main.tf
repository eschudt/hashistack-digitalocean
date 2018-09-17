# modules/firewall/main.tf
# Create a firewall around all servers

variable "server_ids" {
  type = "list"
  description = "list of servers"
}

variable "load_balancer_id" {
  description = "IP Address of load balancer"
}

variable "bastion_id" {
  description = "Droplet id of bastion host"
}

resource "digitalocean_firewall" "web" {
  name = "firewall-1"

  droplet_ids = ["${var.server_ids}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_droplet_ids = ["${var.bastion_id}"]
      source_load_balancer_uids = ["${var.load_balancer_id}"]
    },
    {
      protocol           = "tcp"
      port_range         = "9999"
      source_load_balancer_uids = ["${var.load_balancer_id}"]
    },
    {
      protocol           = "tcp"
      port_range         = "all"
      source_droplet_ids = ["${var.server_ids}"]
    },
    {
      protocol           = "udp"
      port_range         = "all"
      source_droplet_ids = ["${var.server_ids}"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}
