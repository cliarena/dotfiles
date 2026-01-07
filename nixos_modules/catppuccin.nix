{
  config,
  inputs,
  lib,
 host,
  ...
}: let
  module = "_catppuccin";
  description = "catppuccin theme";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager catppuccin;
in {
  imports = [
    # catppuccin.nixosModules.catppuccin
    home-manager.nixosModules.home-manager
  ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    # catppuccin = {
    #   enable = true;
    #   flavor = "mocha";
    #
    #   # Don't use modules with IFD by default
    #   tty.enable = false;
    # };
    home-manager.users.${host.user} = {
      imports = [catppuccin.homeModules.catppuccin];
     catppuccin = {
       enable = false;
       flavor = "mocha";
       # chromium.enable = true;
       qutebrowser.enable = true;
     };
    };
  };
}
