{ config, lib, ... }:
let
  module = "_cloudflare_dyndns";
  description = "cloudflare dynamic dns client";
  inherit (lib) mkEnableOption mkIf;

  DOMAIN = "cliarena.com";
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.cloudflare-dyndns = {
      enable = true;
      domains = [ DOMAIN ];
      proxied = true;
      apiTokenFile = config.sops.secrets.CLOUDFLARE_API_TOKEN.path;
    };
  };
}
