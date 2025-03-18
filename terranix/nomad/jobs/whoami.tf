job "whoami" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "backend" {
    count = 4

    task "whoami" {
      driver = "docker"
      config {
        image = "containous/whoami"
      }
    }
  }
}
