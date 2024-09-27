{ config, lib, ... }:
let
  module = "_twilight";
  deskription = "dims inactive portions of code";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.twilight = { enable = true; };

  };
}