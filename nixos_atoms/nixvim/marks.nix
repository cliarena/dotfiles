{ config, lib, ... }:
let
  module = "_marks";
  deskription = "better mark navigations";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.marks = { enable = true; };
  };

}
