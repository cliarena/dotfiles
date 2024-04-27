{ ... }: {
  services.prometheus.exporters.node.enable = true;

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
