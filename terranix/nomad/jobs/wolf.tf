job "wolf" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "backend" {
    count = 1

    task "server" {
      driver = "docker"
      env {
        XDG_RUNTIME_DIR        = "/tmp/sockets"
        HOST_APPS_STATE_FOLDER = "/srv/volumes/wolf"
      }

      config {
        volumes = [
          "wolf/:/etc/wolf",
          "/tmp/sockets:/tmp/sockets:rw",
          "/var/run/docker.sock:/var/run/docker.sock:rw",
          "/dev/:/dev/:rw",
          "/run/udev:/run/udev:rw",
        ]
        devices = [
          {
            host_path = "/dev/dri"
          },
          {
            host_path = "/dev/uinput"
          },
          {
            host_path = "/dev/uhid"
          }
        ]
        image = "ghcr.io/games-on-whales/wolf:stable"
      }
    }
  }
}
