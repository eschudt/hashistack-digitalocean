# modules/load-balancer/main.tf
# Create a load balancer to connect to servers and clients

variable "server_ids" {
  type = "list"
  description = "list of servers"
}

resource "digitalocean_loadbalancer" "public" {
  name = "loadbalancer-1"
  region = "lon1"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 9999
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = "${var.server_ids}"
}

output "load_balancer_ip" {
  value = "${digitalocean_loadbalancer.public.ip}"
}
