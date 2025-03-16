{ config, lib, pkgs, inputs, host, ... }:
let
  module = "_home_wezterm";
  description = "wezterm config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {
      programs.wezterm = {
        enable = true;

        extraConfig = ''
          return {
            font_size = 9.0,
            line_height = 1.2,
            color_scheme = 'Catppuccin Mocha',
            use_fancy_tab_bar = false,
            hide_tab_bar_if_only_one_tab = true,
            -- default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
            keys = {
              {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
            }
          }
        '';
      };
    };
  };
}
