{ config, lib, ... }:

let inherit (lib) mkEnableOption mkIf;
in {

  imports = lib.fileset.toList ../nixos_modules;

  options.profiles.common.enable = mkEnableOption "conding profile";

  config = mkIf config.profiles.common.enable {

    _swap.enable = true;
    _comin.enable = true;
    _nix.enable = true;

  };
}
