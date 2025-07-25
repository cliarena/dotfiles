{
  time,
  pkgs,
  ...
}: let
  http = {
    mode = "bridge";
    # reservedPorts.http = {
    # static = 8111;
    # to = 8080;
    # };
  };
in {
  job.nginx = {
    datacenters = ["dc1"];

    group.servers = {
      count = 1;

      volume = {
        nix_store = {
          type = "host";
          source = "nix_store";
          readOnly = true;
        };
      };
      networks = [http];
      # networks = [ http { mode = "bridge"; } ];
      services = [
        {
          name = "nginx";
          # WARN: Don't use named ports ie: port ="http". use literal ones
          port = "8080";
          connect = {sidecarService = {};};

          # FIX: check throws error connection refused
          # checks = with time; [{
          # type = "http";
          # path = "/";
          # # protocol = "https";
          # # expose = true;
          # # tlsSkipVerify = true;
          # interval = 3 * second;
          # timeout = 2 * second;
          # }];
        }
      ];
      task.server = {
        driver = "exec";

        volumeMounts = [
          {
            volume = "nix_store";
            destination = "/nix/store";
          }
        ];
        config = {
          # image = "nginxinc/nginx-unprivileged:alpine";
          command = "${pkgs.echoip}/bin/echoip";
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
