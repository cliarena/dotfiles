{ ... }: {
  services.victoriametrics = {
    enable = true;
    # extraOptions = [ "-storageDataPath=/srv/victoriametrics" ];
    listenAddress = ":8428";
    retentionPeriod = 36;
  };
  services.vmagent = {
    enable = true;
    prometheusConfig = builtins.toJSON {
      scrape_configs = [{
        job_name = "nomad";
        nomad_sd_configs = [{ server = "localhost:4646"; }];
      }
      # server is an optional Nomad server to connect to.
      # If the server isn't specified, then it is read from NOMAD_ADDR environment var.
      # If the NOMAD_ADDR environment var isn't set, then localhost:4646 is used.
      #
        ];
    };
  };
  # services.prometheus.exporters.node.enable = true;

}
