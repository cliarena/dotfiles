{
  config,
  lib,
  ...
}: let
  module = "_twilight";
  description = "dims inactive portions of code";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.twilight = {enable = true;};
  };
}
