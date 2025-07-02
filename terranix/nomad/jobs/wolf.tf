job "wolf" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "backend" {

    count = 1

    network {

      port "http" {
        static = 47989
      }
      port "https" {
        static = 47984
      }
      port "control" {
        static = 47999
      }
      port "rtsp" {
        static = 48010
      }

      # audio port for each user
      port "audio_0" {
        static = 48200
      }
      port "audio_1" {
        static = 48201
      }
      port "audio_2" {
        static = 48202
      }
      port "audio_3" {
        static = 48203
      }

      # video port for each user
      port "video_0" {
        static = 48100
      }
      port "video_1" {
        static = 48101
      }
      port "video_2" {
        static = 48102
      }
      port "video_3" {
        static = 48103
      }

    }


    task "server" {
      driver = "docker"
     # user = "svr"

      resources {
        cpu    = 2000
        memory = 4096
      }

      env {
        XDG_RUNTIME_DIR            = "/tmp/sockets"
      #  XDG_RUNTIME_DIR            = "/run/user/1000"
        HOST_APPS_STATE_FOLDER     = "/etc/wolf/state"
        WOLF_DOCKER_FAKE_UDEV_PATH = "/etc/wolf"
      }

      config {
        privileged = true
        group_add = [ "audio", ]       

        ports      = ["http", "https", "control", "rtsp", "audio_0", "audio_1", "audio_2", "audio_3", "video_0", "video_1", "video_2", "video_3", ]

        volumes = [
          "/srv/volumes/wolf:/etc/wolf",
          "/tmp/sockets:/tmp/sockets:rw",
          "/var/run/pulse:/tmp/sockets/pulse:rw",
        #  "/var/run/pulse/native:/tmp/sockets/pulse/pulse-socket:rw",
        #  "/run/user/1000:/run/user/1000:rw",
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
