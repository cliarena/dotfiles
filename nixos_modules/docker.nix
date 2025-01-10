{ config, lib, ... }:
let
  module = "_docker";
  description = "containarization tool";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = { data-root = "/srv/var/lib/docker"; };
    };
  };
}
