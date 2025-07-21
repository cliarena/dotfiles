{
  config,
  lib,
  ...
}: let
  # TODO: move to remember.nvim. lastplace is no longer maintained
  module = "_lastplace";
  description = "remenbers last place in buffers";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.lastplace.enable = true;
  };
}
