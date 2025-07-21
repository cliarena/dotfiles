{
  config,
  lib,
  ...
}: let
  module = "_spider";
  description = "better w,e,b vim movements";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.spider = {
      enable = true;

      keymaps.motions = {
        b = "b";
        e = "e";
        ge = "ge";
        w = "w";
      };
    };
  };
}
