{ config, lib, ... }:
let
  module = "_hardtime";
  deskription = "quit bad vim habits";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.hardtime.enable = true;

  };

}
