job "whoami" {
  
  datacenters = [
  "dc1"
]
  type = "service"

    group "backend" {


        task "whoami" {
            driver = "docker"
            config {
            image = "containous/whoami"
            }
        }
    }
}

