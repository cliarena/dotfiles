{ ... }: {
  services.prometheus.exporters = {
    node.enable = true;
    systemd.enable = true;
    snmp.enable = true;
    smokeping.enable = true; # ping services
    smartctl.enable = true; # HDD health monitor
    script = { # custom scripts checks
      enable = false;
      scripts = [{
        name = "sleep";
        script = "sleep 5";
        timeout = 5;
      }];
    };

  };

  services.victoriametrics = {
    enable = true;
    # extraOptions = [ "-storageDataPath=/srv/victoriametrics" ];
    listenAddress = ":8428";
    retentionPeriod = 36;
  };
  services.vmagent = {
    enable = true;
    prometheusConfig = {
      scrape_configs = [
        # Never use "localhost" to avoid dns lookup latency
        {
          job_name = "nomad";
          nomad_sd_configs = [{ server = "127.0.0.1:4646"; }];
        }
        {
          job_name = "node";
          static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
        }
      ];
    };
  };

}
