# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/server"

bind_addr = "server_ip" # edit to private network

advertise {
  # Edit to the private IP address.
  http = "server_ip:4646"
  rpc  = "server_ip:4647"
  serf = "server_ip:4648" # non-default ports may be specified
}

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = server_count
}

# Enable a client on the same node
client {
  enabled = true
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

consul {
  address             = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

vault {
  enabled = true
  address = "http://127.0.0.1:8200"
}
