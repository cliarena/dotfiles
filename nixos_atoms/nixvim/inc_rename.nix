{ config, lib, ... }:
let
  module = "_inc_rename";
  description = "live incremental renaming";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.inc-rename.enable = true;

  };

}
