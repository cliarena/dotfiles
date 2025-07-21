{
  config,
  lib,
  ...
}: let
  module = "_better_escape";
  description = "escape without delay";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.better-escape = {
      enable = true;
      settings = {
        default_mappings = false;
        mappings = {i = {i = {i = "<Esc>";};};};
      };
    };
  };
}
