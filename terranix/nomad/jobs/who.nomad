job "who" {

  datacenters = [
  "dc1"
]
  type = "service"

    group "backend" {
      count = 0

        task "whoami" {
            driver = "docker"
            config {
            image = "containous/whoami"
            }
        }
    }
}
