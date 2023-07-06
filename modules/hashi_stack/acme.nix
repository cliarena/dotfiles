{ config, DOMAIN, VAULT_ADDR, ... }: {
  security.acme = {
    acceptTerms = true;

    defaults = {

      dnsProvider = "cloudflare";
      email = "reporter@${DOMAIN}";
      # webroot = "/var/lib/acme/acme-challenge/";
    };
    certs = {
      ${VAULT_ADDR} = {
        group = "vault";
        credentialsFile = config.sops.secrets.ACME_VAULT_CERT_CREDENTIALS.path;
      };
      # "cliarena.com" = {
      #   group = "vault";
      #   credentialsFile = ./cliarena.com;
      #   extraDomainNames = [ "*.cliarena.com" ];
      # };
    };
  };
}
