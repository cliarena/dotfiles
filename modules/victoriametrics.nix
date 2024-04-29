{ ... }: {
  services.prometheus.exporters = {

    ### Linux processes ###
    node.enable = true;
    process.enable = false; # monitor specefic process
    systemd.enable = true;

    script = { # custom scripts checks
      enable = false;
      scripts = [{
        name = "sleep";
        script = "sleep 5";
        timeout = 5;
      }];
    };

    ### Networking ###
    snmp.enable = true;
    smokeping.enable = true; # ping services

    ### DB ###
    sql.enable = true; # custom SQL queries
    redis.enable = false;
    postgres.enable = false;

    ### Caching ###
    varnish.enable = false; # reverse proxy Cache

    ### Hardware ###
    smartctl.enable = true; # HDD health monitor
    scaphandre.enable = true; # Electricity consumption for bare metal & vms

    ### Spam ###
    rspamd.enable = false; # Email/messages spam fileterer

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
