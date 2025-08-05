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

    
    task "pulse_cleaner" {
      lifecycle {
        hook = "prestart"
      }
      driver = "raw_exec"

      config {
        command = "/run/current-system/sw/bin/sh"
        args = [ "-c", "/run/current-system/sw/bin/sudo /run/current-system/sw/bin/podman rm -f WolfPulseAudio" ]
      }

    }

    task "server" {
      driver = "podman"
     # driver = "docker"

      resources {
        cpu    = 2000
        memory = 4096
      }

      env {
        XDG_RUNTIME_DIR            = "/tmp/sockets"
        HOST_APPS_STATE_FOLDER     = "/etc/wolf/state"
        WOLF_DOCKER_FAKE_UDEV_PATH = "/etc/wolf"
        WOLF_DOCKER_SOCKET = "/var/run/podman/podman.sock"
        # Must remove pulse container if already running + increase timeout if needed
        WOLF_PULSE_CONTAINER_TIMEOUT_MS = 5000 
        
        # WOLF_LOG_LEVEL = "DEBUG"
      }

      config {
        privileged = true
        ports      = ["http", "https", "control", "rtsp", "audio_0", "audio_1", "audio_2", "audio_3", "video_0", "video_1", "video_2", "video_3", ]

        volumes = [
          "/srv/volumes/wolf:/etc/wolf",
          "/tmp/sockets:/tmp/sockets:rw",
        #  "/var/run/docker.sock:/var/run/docker.sock:rw",
          "/var/run/podman/podman.sock:/var/run/podman/podman.sock:rw",
          "/dev/:/dev/:rw",
          "/run/udev:/run/udev:rw",
        ]

        devices = [
          "/dev/dri",
          "/dev/uinput",
          "/dev/uhid",

       # Docker config
       #   {
       #     host_path = "/dev/dri"
       #   },
       #   {
       #     host_path = "/dev/uinput"
       #   },
       #   {
       #     host_path = "/dev/uhid"
       #   }
        ]
        image = "ghcr.io/games-on-whales/wolf:stable"
      }
    }
  }
}
