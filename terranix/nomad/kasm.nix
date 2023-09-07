{ time, ... }:
let
  http = {
    mode = "bridge";
    #reservedPorts.wizard = {
    #  static = 3000;
    #  to = 3000;
    #};
    #reservedPorts.http = {
    #  static = 8443;
    #  to = 443;
    #};
  };
in {
  job.kasm = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      volume = {
        kasm_data = {
          type = "host";
          source = "kasm_data";
          readOnly = false;
        };
        kasm_profiles = {
          type = "host";
          source = "kasm_profiles";
          readOnly = false;
        };
      };

      networks = [ http ];
      #      mode = "bridge"

      services = [{
        name = "kasm";
        # WARN: Don't use named ports ie: port ="http". use literal ones
        port = "443";
        connect = {
          sidecarService = {
            # port = "20000";
          };
        };
      }];
      task.server = {
        driver = "docker";

        env = { KASM_PORT = "443"; };

        volumeMounts = [
          {
            volume = "kasm_data";
            destination = "/opt";
          }
          {
            volume = "kasm_profiles";
            destination = "/profiles";
          }
        ];

        config = {
          image = "lscr.io/linuxserver/kasm:latest";
          privileged = true;
          # ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
        };

        resources = {
          cpu = 4000;
          memory = 4000;
        };

        #services = [{
        #   name = "kasm";
        # port = "http";

        #  tags = [ "kasm" ];

        #  checks = with time; [{
        #    type = "http";
        #    path = "/api/__healthcheck";
        #    interval = 2 * second;
        #    timeout = 2 * second;
        #  }];
        # }];
      };
    };
  };
}
