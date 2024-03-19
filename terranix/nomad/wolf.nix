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
      autio = {
        static = 48200;
        to = 48200;
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

        config = {
          image = "ghcr.io/games-on-whales/wolf:stable";
          #	image = "mysql"
          # ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
        };
        resources = {
          cpu = 10;
          memory = 50;
        };
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
