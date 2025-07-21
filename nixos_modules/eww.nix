{
  config,
  lib,
  inputs,
  host,
  ...
}: let
  module = "_eww";
  description = "wayland widget system made in rust";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {
  imports = [home-manager.nixosModules.home-manager];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    home-manager.users.${host.user} = {...}: {
      programs.eww = {
        enable = true;
        configDir = ../nixos_atoms/eww;
      };
    };
  };
}
