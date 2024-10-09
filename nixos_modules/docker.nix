{ config, lib, ... }:
let
  module = "_docker";
  deskription = "containarization tool";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config =
    mkIf config.${module}.enable { virtualisation.docker.enable = true; };
}
