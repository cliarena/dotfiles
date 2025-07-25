{
  config,
  lib,
  ...
}: let
  module = "_victoria_metrics";
  description = "monitoring that scales";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    system.activationScripts = {
      scaphandre.text = "chown -R scaphandre-exporter /sys/devices/virtual/powercap";
    };

    services.prometheus.exporters = {
      ### Linux processes ###
      node.enable = true;
      process.enable = false; # monitor specefic process
      systemd = {
        enable = true;
        extraFlags = [
          "--systemd.collector.enable-restart-count"
          "--systemd.collector.enable-ip-accounting"
          # "--systemd.collector.enable-file-descriptor-size" # throws unknown flag error
        ];
      };

      script = {
        # custom scripts checks
        enable = false;
        settings.scripts = [
          {
            name = "sleep";
            script = "sleep 5";
            timeout = 5;
          }
        ];
      };

      ### Networking ###
      snmp.enable = false;
      smokeping.enable = false; # best latency monitor
      blackbox.enable = false; # HTTP, HTTPS, DNS, TCP, ICMP and gRPC prober
      nats.enable = false; # nats.io. needs system update
      modemmanager.enable = false; # mobile broadband (4G/5G) management system
      lnd.enable = false; # monitor Blockchain/P2P networking
      ipmi.enable = false; # monitor IPMI: remote full pc w/ bios access

      ### Mail ###
      mail.enable = false; # monitor mail servers
      imap-mailstat.enable = false; # shows how many mails in inbox & each folder

      ### API ###
      json.enable = false; # scrapes remote JSON

      ### DNS ###
      knot.enable = false;
      domain.enable = false; # Domains expiration date
      dnssec.enable = false; # DNSSEC signatures validity and expiration
      dnsmasq.enable = false; # DNSSEC signatures validity and expiration
      dmarc.enable = false; # Domains reports: unauthorized use, email spoofing

      ### DHCP ###
      kea.enable = false;

      ### Ad blockers ###
      pihole.enable = false; # Ad blocker

      ### Storage ###
      nextcloud.enable = false;

      ### Object Storage ###

      ### DB ###
      sql.enable = false; # custom SQL queries
      redis.enable = false;
      mysqld.enable = false; # mysql & mariadb
      postgres.enable = false;
      mongodb.enable = false;
      influxdb.enable = false;

      ### Caching ###
      varnish.enable = false; # reverse proxy Cache

      ### Hardware ###
      smartctl.enable = true; # HDD health monitor
      # scaphandre.enable = true; # Electricity consumption for bare metal & vms
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
      retentionPeriod = "6"; # 6 months
    };
    services.vmagent = {
      enable = true;
      remoteWrite.url = "http://127.0.0.1:8428/api/v1/write";
      prometheusConfig = {
        scrape_configs = [
          # Never use "localhost" to avoid dns lookup latency
          {
            job_name = "vault";
            static_configs = [
              {
                targets = [
                  "https://vault.cliarena.com:8200/v1/sys/metrics?format=prometheus"
                ];
              }
            ];
            authorization.credentials_file = config.sops.secrets.VICTORIA_METRICS_VAULT_TOKEN.path;
          }
          {
            job_name = "nomad";
            static_configs = [
              {
                targets = ["127.0.0.1:4646/v1/metrics?format=prometheus"];
              }
            ];
          }
          {
            job_name = "nomad_sd";
            consul_sd_configs = [{server = "127.0.0.1:4646";}];
          }
          {
            job_name = "consul";
            static_configs = [
              {
                targets = ["127.0.0.1:8500/v1/agent/metrics?format=prometheus"];
              }
            ];
          }
          {
            job_name = "consul_sd";
            consul_sd_configs = [{server = "127.0.0.1:8500";}];
          }
          {
            job_name = "envoy";
            static_configs = [{targets = ["127.0.0.1:8484"];}];
          }
          {
            job_name = "node";
            static_configs = [{targets = ["127.0.0.1:9100"];}];
          }
          {
            job_name = "systemd";
            static_configs = [{targets = ["127.0.0.1:9558"];}];
          }
          {
            job_name = "vmetrics";
            static_configs = [{targets = ["127.0.0.1:8428"];}];
          }
        ];
      };
    };
  };
}
