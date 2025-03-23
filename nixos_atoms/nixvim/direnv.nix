{ config, lib, ... }:
let
  module = "_nvim_direnv";
  description = "setup environment";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.direnv = { enable = true; };

  };
}
