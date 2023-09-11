job "echo" {
  datacenters = ["dc1"]

  group "echo" {
    network {
      mode = "bridge"
    }

    service {
      name = "echo"
      port = "8443"
      # port = "8080" # works

      connect {
        sidecar_service {}
      }
    }

    task "echo" {
      driver = "docker"

      config {
        image = "mendhak/http-https-echo"
      }
    }
  }
}

