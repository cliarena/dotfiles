{ config, lib, ... }:
let
  module = "_mini";
  deskription = "mini modules";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        bufremove = { };
        completion = { };
      };
    };
  };

}
