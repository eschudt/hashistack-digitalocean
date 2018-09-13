# modules/firewall/main.tf
# Create a firewall around all servers

variable "server_ids" {
  type = "list"
  description = "list of servers"
}

variable "load_balancer_ip" {
  description = "IP Address of load balancer"
}

variable "bastion_ip" {
  description = "IP Address of bastion host"
}

resource "digitalocean_firewall" "web" {
  name = "firewall-1"

  droplet_ids = "${var.server_ids}"

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["${var.bastion_ip}/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["${var.load_balancer_ip}/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["${var.load_balancer_ip}/0"]
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
