{ config, lib, ... }:
let
  module = "hosting";
  deskription = "hosting profile";
  inherit (lib) mkEnableOption mkIf fileset;
in {

  imports = fileset.toList ../nixos_modules;

  options.profiles.${module}.enable = mkEnableOption deskription;

  config = mkIf config.profiles.${module}.enable {

    _hydra.enable = true;
    _auditd.enable = true;
    _impermanence.enable = true;

    _docker.enable = true;
    _nomad.enable = true;

    _victoria_metrics.enable = false;
  };
}
