job "whoami" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "backend" {
    count = 3

    task "whoami" {
      driver = "podman"
      config {
        image = "containous/whoami"
      }
    }
  }
}
