{ config, lib, ... }:
let
  module = "_neorg";
  description = "org mode for neovim";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.neorg = { enable = true; };
  };

}
