{ config, lib, pkgs, ... }:

let inherit (lib) mkEnableOption mkIf;
in {

  imports = lib.fileset.toList ../nixos_modules;

  options.profiles.common.enable = mkEnableOption "conding profile";

  config = mkIf config.profiles.common.enable {

    swap.enable = true;
    comin.enable = true;
    _nix.enable = true;

  };
}
