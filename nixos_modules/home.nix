{ config, lib, inputs, host, ... }:
let
  module = "_home";
  description = "user home config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.useGlobalPkgs = true; # breaks nixvim
    home-manager.useUserPackages = true;
    home-manager.users.${host.user} = {
      home = {
        stateVersion = "22.11";
        username = host.user;
        homeDirectory = "/home/${host.user}";
      };
      programs.home-manager.enable = true;

    };
  };

}
