{ config, lib, pkgs, inputs, host, ... }:
let
  module = "_home_files";
  description = "files to add to home dir";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {

      home.file = { notes.source = inputs.home_notes; };
    };
  };
}
