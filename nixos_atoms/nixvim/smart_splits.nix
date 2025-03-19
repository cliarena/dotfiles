{ config, lib, ... }:
let
  module = "_smart_splits";
  description =
    "Seamless navigatio & resizing for neovim + terminal multiplexers";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.smart-splits = {

      enable = true;

    };

  };
}
