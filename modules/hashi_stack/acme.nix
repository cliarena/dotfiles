{ config, DOMAIN, VAULT_ADDR, ... }: {
  security.acme = {
    acceptTerms = true;

    defaults = {

      dnsProvider = "cloudflare";
      email = "reporter@${DOMAIN}";
      # webroot = "/var/lib/acme/acme-challenge/";
    };
    certs = {
      # "${DOMAIN}" = {
      "cliarena.com" = {
        # group = "vault";
        # change this or add to it, if reached letsencrypt Rate limit
        extraDomainNames = [ "*.cliarena.com" ];
        credentialsFile = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
        # reloadServices = [ "vault.service" ];
      };
      "vault.cliarena.com" = {
        group = "vault";
        # change this or add to it, if reached letsencrypt Rate limit
        credentialsFile = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
        reloadServices = [ "vault.service" ];
      };
    };
  };
}
