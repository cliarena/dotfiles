{ time, ... }:
let
  http = {
    reservedPorts.wizard = {
      static = 3000;
      to = 3000;
    };
    reservedPorts.http = {
      static = 443;
      to = 443;
    };
  };
in {
  job.kasm = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      volume = {
        kasm_storage = {
          type = "host";
          source = "kasm_storage";
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

      task.server = {
        driver = "podman";

        env = { KASM_PORT = "443"; };

        volumeMounts = [
          {
            volume = "kasm_storage";
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
          ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
        };

        resources = {
          cpu = 4000;
          memory = 4000;
        };

        services = [{
          name = "kasm";
          port = "http";

          tags = [ "kasm" ];

          checks = with time; [{
            type = "http";
            path = "/api/__healthcheck";
            interval = 2 * second;
            timeout = 2 * second;
          }];
        }];
      };
    };
  };
}
