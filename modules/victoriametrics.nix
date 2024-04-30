{ ... }: {
  services.prometheus.exporters = {

    ### Linux processes ###
    node.enable = true;
    process.enable = false; # monitor specefic process
    systemd = {
      enable = true;
      extraFlags = [
        "--systemd.collector.enable-restart-count"
        "--systemd.collector.enable-file-descriptor-size"
        "--systemd.collector.enable-ip-accounting"
      ];
    };

    script = { # custom scripts checks
      enable = false;
      settings.scripts = [{
        name = "sleep";
        script = "sleep 5";
        timeout = 5;
      }];
    };

    ### Networking ###
    ping.enable = true; # ICMP echo requests
    snmp.enable = true;
    smokeping.enable = true; # ping services
    # nats.enable = false; # needs system update
    modemmanager.enable = false; # mobile broadband (4G/5G) management system
    lnd.enable = false; # monitor Blockchain/P2P networking
    ipmi.enable = false; # monitor IPMI: remote full pc w/ bios access

    ### Mail ###
    mail.enable = false; # monitor mail servers
    imap-mailstat.enable = false; # shows how many mails in inbox & each folder

    ### API ###
    json.enable = true; # scrapes remote JSON

    ### DNS ###
    knot.enable = false;

    ### DHCP ###
    kea.enable = false;

    ### Ad blockers ###
    pihole.enable = false; # Ad blocker

    ### Storage ###
    nextcloud.enable = false;

    ### Object Storage ###
    minio.enable = false;

    ### DB ###
    sql.enable = true; # custom SQL queries
    redis.enable = false;
    mysqld.enable = false; # mysql & mariadb
    postgres.enable = false;
    mongodb.enable = false;
    influxdb.enable = false;

    ### Caching ###
    varnish.enable = false; # reverse proxy Cache

    ### Hardware ###
    smartctl.enable = true; # HDD health monitor
    scaphandre.enable = true; # Electricity consumption for bare metal & vms
    nut.enable = false; # Network UPS monitor

    ### Reverse Proxies ###
    nginx.enable = false;

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
