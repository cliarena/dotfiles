{ config, lib, ... }:
let
  module = "_spider";
  deskription = "better w,e,b vim movements";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

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
