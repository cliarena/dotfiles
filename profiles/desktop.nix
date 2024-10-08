{ config, lib, ... }:
let
  module = "desktop";
  deskription = "desktop profile";
  inherit (lib) mkEnableOption mkIf fileset;
in {

  imports = fileset.toList ../nixos_modules;

  options.profiles.${module}.enable = mkEnableOption deskription;

  config = mkIf config.profiles.${module}.enable {

    fonts.enable = true;
    _pipewire.enable = true;
    _pkgs_desktop.enable = true;

  };
}
