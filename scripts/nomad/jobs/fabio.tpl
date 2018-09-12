job "fabio" {

  datacenters = ["dc1"]

  type = "system"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {

    task "fabio" {

      driver = "exec"

      config {
        command = "fabio-1.5.9-go1.10.2-linux_386"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.9/fabio-1.5.9-go1.10.2-linux_386"
      }

      resources {
        cpu = 500
        memory = 64
        network {
          mbits = 1
          port "http" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
