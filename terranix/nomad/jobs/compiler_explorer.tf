job "compiler_exlorer" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "server" {
    count = 1
    network {
      port "http" {
        static = 10240
      }
    }

    task "server" {
      driver = "podman"
      config {
        ports      = ["http"]
        image = "madduci/docker-compiler-explorer:latest"
      }
    }
  }
}
