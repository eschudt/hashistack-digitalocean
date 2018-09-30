# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/client"

# Give the agent a unique name. Defaults to hostname
# name = "client"

# Enable the client
client {
    enabled = true
}

ports {
    http = 5657
}

consul {
  address             = "127.0.0.1:8500"
  client_service_name = "nomad-client-countIndex"
  auto_advertise      = true
  client_auto_join    = true
}

vault {
  enabled = true
  address = "http://127.0.0.1:8200"
}
