{ config, DOMAIN, VAULT_ADDR, ... }: {
  security.acme = {
    acceptTerms = true;

    defaults = {

      dnsProvider = "cloudflare";
      email = "reporter@${DOMAIN}";
      # webroot = "/var/lib/acme/acme-challenge/";
    };
    certs = {
      "vault.${DOMAIN}" = {
        group = "vault";
        directory = "/srv/vault/certs";
        # change this or add to it, if reached letsencrypt Rate limit
        extraDomainNames = [ "cliarena.com" ];
        credentialsFile = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
        reloadServices = [ "vault.service" ];
      };
      # "cliarena.com" = {
      #   group = "vault";
      #   credentialsFile = ./cliarena.com;
      #   extraDomainNames = [ "*.cliarena.com" ];
      # };
    };
  };
}
