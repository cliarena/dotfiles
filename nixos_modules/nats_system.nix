{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_nats_system";
  description = "NATS messaging system";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = with pkgs; [natscli nats-top];

    services.nats = {
      enable = true;
      jetstream = true;
      # dataDir = "/var/lib/nats";
    };
  };
}
