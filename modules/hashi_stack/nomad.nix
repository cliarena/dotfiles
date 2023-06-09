{ config, pkgs, CONSUL_ADDR, VAULT_ADDR, ... }: {
  services.nomad = {
    enable = true;
    # needed by Podman driver maybe others too
    dropPrivileges = false;
    enableDocker = false;
    extraSettingsPlugins = [ pkgs.nomad-driver-podman ];
    extraSettingsPaths =
      [ config.sops.secrets."NOMAD_GOSSIP_ENCRYPTION_KEY.hcl".path ];
    settings = {
      ui = {
        enabled = true;
        consul = { ui_url = "${CONSUL_ADDR}/ui"; };
        vault = { ui_url = "${VAULT_ADDR}/ui"; };
      };
      # vault = {
      # enabled = true;
      # address = "http://vault.cliarena.com:8200";
      # };
      # tls = {
      #   http = true;
      #   rpc = true;
      #   # /var/lib/acme/cliarena.com/cert.pem
      #   ca_file = "/etc/certs/ca.crt";
      #   cert_file = "/etc/certs/nomad.crt";
      #   key_file = "/var/lib/acme/cliarena.com/key.pem";
      #
      #   verify_server_hostname = true;
      #   verify_https_client = true;
      # };

      server = {
        enabled = true;
        bootstrap_expect = 1; # for demo; no fault tolerance
        # able to access sops secrets because dropPrivileges =  false;
      };

      client = {
        enabled = true;
        # cpu_total_compute = 4 * 2200;
        memory_total_mb = 2 * 64 * 1024; # double the ram to benefit from zram
        host_volume = {
          # vaultwarden = {
          # path = "/vault/hdd/nomad/host-volumes/vaultwarden";
          # read_only = false;
          # };
          # mysql = {
          # path = "/vault/hdd/nomad/host-volumes/mysql-test";
          # read_only = false;
          # };
          # waypoint-server = {
          # path = "/vault/hdd/nomad/host-volumes/wp-server";
          # read_only = false;
          # };
          # waypoint-runner = {
          # path = "/vault/hdd/nomad/host-volumes/wp-runner";
          # read_only = false;
          # };
        };
      };
    };
  };
}
