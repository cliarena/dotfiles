{ config, lib, ... }:
let
  module = "_yanky";
  deskription = "better yanking";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.yanky = { enable = true; };

  };
}
