{ config, lib, ... }:
let
  module = "_inc_rename";
  deskription = "live incremental renaming";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.inc-rename.enable = true;

  };

}
