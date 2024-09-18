{ config, lib, ... }:
let
  # TODO: move to remember.nvim. lastplace is no longer maintained
  module = "_lastplace";
  deskription = "remenbers last place in buffers";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.lastplace.enable = true;

  };

}
