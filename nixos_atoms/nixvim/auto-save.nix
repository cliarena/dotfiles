{ config, lib, ... }:
let
  module = "_auto_save";
  deskription = "auto save";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.auto-save.enable = true;

  };

}
