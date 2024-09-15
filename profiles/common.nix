{ config, lib, ... }:

let inherit (lib) mkEnableOption mkIf;
in {

  imports = lib.fileset.toList ../nixos_modules;

  options.profiles.common.enable = mkEnableOption "conding profile";

  config = mkIf config.profiles.common.enable {

    _nix.enable = true;
    _swap.enable = true;
    _users.enable = true;
    _comin.enable = true;
    _local.enable = true;

  };
}
