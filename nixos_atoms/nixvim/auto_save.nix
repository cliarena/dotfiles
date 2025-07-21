{
  config,
  lib,
  ...
}: let
  module = "_auto_save";
  description = "auto save";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.auto-save.enable = true;
  };
}
