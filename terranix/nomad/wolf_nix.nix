{time, ...}: let
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
    };
  };
in {
  job.wolf = {
    datacenters = ["dc1"];

    group.servers = {
      count = 1;

      networks = [http];
      # networks = [ http { mode = "bridge"; } ];
      services = [
        {
          name = "wolf";
          # WARN: Don't use named ports ie: port ="http". use literal ones
          port = "47989";
          # connect = { sidecarService = { }; };
        }
      ];
      task.server = {
        driver = "raw_exec";

        config = {command = "/run/current-system/sw/bin/wolf";};
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
