job "echo" {
  datacenters = ["dc1"]

  group "echo" {
    network {
      mode = "bridge"
      #port "https" {
        #static = 8443
        #}
    }
    volume "certs_fullchain" {
      type = "host"
      read_only = true
      source = "certs_fullchain"
    }
    volume "certs_privkey" {
      type = "host"
      read_only = true
      source = "certs_privkey"
    }


    service {
      #      provider = "nomad"

      name = "echo"
      port = "8443"
      # port = "8080" # works

      connect {
        sidecar_service {}
      }
    }

    task "echo" {

      volume_mount {
        volume      = "certs_fullchain"
        destination = "/app/fullchain.pem"
      }
      volume_mount {
        volume      = "certs_privkey"
        destination = "/app/privkey.pem"
      }


      driver = "docker"

      config {
        image = "mendhak/http-https-echo"
        privileged = true
        # ports = ["https"]

      }
    }
  }
}

