{ config, pkgs, DOMAIN, VAULT_ADDR, ... }:

let cfg = config.services.vault;
in {

  environment.variables = { inherit VAULT_ADDR; };
  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    tlsCertFile = "/var/lib/acme/vault.${DOMAIN}/cert.pem";
    tlsKeyFile = "/var/lib/acme/vault.${DOMAIN}/key.pem";
    storageBackend = "raft";
    storageConfig = ''
      retry_join {
        leader_tls_servername = "vault"
      }
    '';
    storagePath =
      if cfg.storageBackend == "file" || cfg.storageBackend == "raft" then
        "/srv/vault/data"
      else
        null;
    extraConfig = ''
      ui = true
      api_addr= "https://vault.${DOMAIN}"
      cluster_addr= "https://vault.${DOMAIN}:8201"

      # register vault as a service in consul
      service_registration "consul" {
        address      = "0.0.0.0:8500"
      }
    '';
    # listenerExtraConfig = ''
    # tls_require_and_verify_client_cert = "true"
    # tls_client_ca_file = "${builtins.path { path = ./pki/origin.cert.pem; }}"
    # '';
    # address = "10.10.0.10:8200";
    address = "vault.${DOMAIN}:8200";

    telemetryConfig = ''
      prometheus_retention_time = "30s"
      disable_hostname = true
    '';
  };

  systemd.services.vault.after = [ "acme-vault.${DOMAIN}.service" ];

}
