{ config, DOMAIN, ... }: {
  services.cloudflare-dyndns = {
    enable = true;
    domains = [ DOMAIN ];
    proxied = true;
    apiTokenFile = config.sops.secrets.CLOUDFLARE_API_TOKEN.path;
  };
}
