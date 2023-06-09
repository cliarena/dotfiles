{ time, ... }:
let
  http = {
    port.http = {
      static = 80;
      to = 8080;
    };
  };
in {
  job.nginx = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      networks = [ http ];
      #      mode = "bridge"

      task.server = {
        driver = "podman";

        config = {
          image = "nginxinc/nginx-unprivileged:alpine";
          #	image = "mysql"
          ports = [ "http" ];
          #	volumes = [  "/vault/hdd/nomad/static-site:/usr/share/nginx/html" ]
        };
        resources = {
          cpu = 10;
          memory = 50;
        };
        services = [{
          name = "nginx-server";
          port = "http";

          tags = [ "pi" "nginx-test-server" ];

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
