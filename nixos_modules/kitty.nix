{ config, lib, pkgs, inputs, host, ... }:
let
  module = "_kitty";
  description = "gpu based terminal";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {
      programs.kitty = {
        enable = true;
        font = {
          # name = "FiraCode Nerd Font Mono";
          name = "JetBrainsMono nerd font";
          size = 9;
        };
        themeFile = "Catppuccin-Mocha";
        settings = {
          shell = "${pkgs.nushell}/bin/nu";
          adjust_line_height = "120%";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          wayland_titlebar_color = "background";
        };
      };
    };
  };
}
