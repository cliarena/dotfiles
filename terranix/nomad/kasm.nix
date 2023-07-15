{ time, ... }:
let
  http = {
    port.wizard = {
      static = 80;
      to = 3000;
    };
    port.http = {
      static = 80;
      to = 3003;
    };
  };
in {
  job.kasm = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      volume.kasm = {
        type = "host";
        source = "kasm";
        read_only = false;
      };

      networks = [ http ];
      #      mode = "bridge"

      task.server = {
        driver = "podman";

        env = { KASM_PORT = 3003; };

        volume_mount = {
          volume = "kasm";
          destination = "/";
        };

        config = {
          image = "lscr.io/linuxserver/kasm:latest";
          ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
        };

        resources = {
          cpu = 10;
          memory = 50;
        };

        services = [{
          name = "kasm";
          port = "http";

          tags = [ "kasm" ];

          checks = with time; [{
            type = "http";
            path = "/index.html";
            interval = 2 * second;
            timeout = 2 * second;
          }];
        }];
      };
    };
  };
}
