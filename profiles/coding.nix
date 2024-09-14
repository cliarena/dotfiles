{ config, lib, ... }:

let inherit (lib) mkEnableOption mkIf;
in {

  imports = lib.fileset.toList ../nixos_modules;

  options.profiles.coding.enable = mkEnableOption "conding profile";

  config = mkIf config.profiles.coding.enable {

    fonts.enable = true;
  };
}
