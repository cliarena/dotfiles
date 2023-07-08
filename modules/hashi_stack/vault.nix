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
       api_addr= "https://${DOMAIN}"
       cluster_addr= "https://${DOMAIN}:8201"
    '';
    # listenerExtraConfig = ''
    # tls_require_and_verify_client_cert = "true"
    # tls_client_ca_file = "${builtins.path { path = ./pki/origin.cert.pem; }}"
    # '';
    address = "0.0.0.0:8200";
  };
  systemd.services.vault.after = [ "acme-vault.${DOMAIN}.service" ];

}
