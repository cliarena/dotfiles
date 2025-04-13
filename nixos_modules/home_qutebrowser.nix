{ config, lib, pkgs, inputs, host, ... }:
let
  module = "_home_qutebrowser";
  description = "qutebrowser config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {
      programs.qutebrowser = { enable = true; };
    };
  };
}
