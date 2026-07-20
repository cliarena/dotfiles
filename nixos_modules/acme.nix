{
  config,
  lib,
  ...
}:
let
  module = "_acme";
  description = "automatic certificate management environment";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        dnsProvider = "cloudflare";
        email = "reporter@cliarena.com";
        # webroot = "/var/lib/acme/acme-challenge/";
      };
      certs = {
        "cliarena.com" = {
          # group = "vault";
          # change this or add to it, if reached letsencrypt Rate limit
          extraDomainNames = [ "*.cliarena.com" ];
          credentialFiles = {
            "VAULT_SECRET_FILE" = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
            # "RFC2136_TSIG_SECRET_FILE" = "/run/secrets/tsig-secret-example.org";
          };
          # reloadServices = [ "vault.service" ];
        };
        # "vault.cliarena.com" = {
        #   group = "vault";
        #   # change this or add to it, if reached letsencrypt Rate limit
        #   # credentialsFile = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
        #   "VAULT_SECRET_FILE" = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
        #   reloadServices = [ "vault.service" ];
        # };
      };
    };
  };
}
