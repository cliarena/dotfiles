{
  config,
  lib,
  ...
}: let
  module = "_marks";
  description = "better mark navigations";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.marks = {enable = true;};
  };
}
