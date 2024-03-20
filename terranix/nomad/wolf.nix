{ time, ... }:
let
  http = {
    mode = "bridge";
    reservedPorts = {
      https = {
        static = 47984;
        to = 47984;
      };
      http = {
        static = 47989;
        to = 47989;
      };
      control = {
        static = 47999;
        to = 47999;
      };
      rtsp = {
        static = 48010;
        to = 48010;
      };
      video = {
        static = 48100;
        to = 48100;
      };
      audio = {
        static = 48200;
        to = 48200;
      };
      video1 = {
        static = 48101;
        to = 48101;
      };
      autio1 = {
        static = 48201;
        to = 48201;
      };
      # # Control
      # EXPOSE 47999/udp
      # # RTSP
      # EXPOSE 48010/tcp
      # # Video (up to 10 users)
      # EXPOSE 48100-48110/udp
      # # Audio (up to 10 users)
      # EXPOSE 48200-48210/udp
    };
  };
in {
  job.wolf = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      volume = {
        wolf = {
          type = "host";
          source = "wolf";
          readOnly = false;
        };
        docker_socket = {
          type = "host";
          source = "docker_socket";
          readOnly = false;
        };
        shared_mem = {
          type = "host";
          source = "shared_mem";
          readOnly = false;
        };
        dev_input = {
          type = "host";
          source = "dev_input";
          readOnly = false;
        };
        dev_dri = {
          type = "host";
          source = "dev_dri";
          readOnly = false;
        };
        dev_uinput = {
          type = "host";
          source = "dev_uinput";
          readOnly = false;
        };
        udev = {
          type = "host";
          source = "udev";
          readOnly = false;
        };
      };
      networks = [ http ];
      # networks = [ http { mode = "bridge"; } ];
      services = [{
        name = "wolf";
        # WARN: Don't use named ports ie: port ="http". use literal ones
        port = "47989";
        # connect = { sidecarService = { }; };

      }];
      task.server = {
        driver = "docker";

        env = {
          XDG_RUNTIME_DIR = "/tmp/sockets";
          HOST_APPS_STATE_FOLDER = "/etc/wolf";
        };

        volumeMounts = [
          {
            volume = "wolf";
            destination = "/etc/wolf";
          }
          {
            volume = "docker_socket";
            destination = "/var/run/docker.sock";
          }
          {
            volume = "shared_mem";
            destination = "/dev/shm";
          }
          {
            volume = "dev_input";
            destination = "/dev/input";
          }
          {
            volume = "dev_dri";
            destination = "/dev/dri";
          }
          {
            volume = "dev_uinput";
            destination = "/dev/uinput";
          }
          {
            volume = "udev";
            destination = "/run/udev";
          }
        ];
        config = {
          image = "ghcr.io/games-on-whales/wolf:stable";
          #	image = "mysql"
          # ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
          privileged = true;
          devices =
            [ { host_path = "/dev/dri"; } { host_path = "/dev/uinput"; } ];
        };
        # resources = {
        # cpu = 10;
        # memory = 50;
        # };
        # services = [{
        # name = "nginx";
        # port = "http";
        # tags = [ "pi" "nginx-test-server" ];
        # checks = with time; [{
        # type = "http";
        # path = "/index.html";
        # interval = 2 * second;
        # timeout = 2 * second;
        # }];
        # }];
      };
    };
  };
}
