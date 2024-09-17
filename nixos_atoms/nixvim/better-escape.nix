{ config, lib, ... }:
let
  module = "_better_escape";
  deskription = "escape without delay";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.better-escape = {
      enable = true;
      settings = {
        default_mappings = false;
        mappings = { i = { i = { i = "<Esc>"; }; }; };
      };
    };
  };

}
