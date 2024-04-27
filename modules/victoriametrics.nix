{ ... }: {
  services.victoriametrics = {
    enable = true;
    # extraOptions = [ "-storageDataPath=/srv/victoriametrics" ];
    listenAddress = ":8428";
    retentionPeriod = 36;
  };
  services.vmagent = {
    enable = true;
    prometheusConfig = {
      scrape_configs = [{
        job_name = "nomad";
        nomad_sd_configs = [{ server = "localhost:4646"; }];
      }];
    };
  };
  # services.prometheus.exporters.node.enable = true;

}
