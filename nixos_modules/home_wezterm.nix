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
            line_height = 1.2,
            font_size = 8.7, -- 8.6 fixes ===

            bold_brightens_ansi_colors = "BrightAndBold",
            color_scheme = 'Catppuccin Mocha',

            window_padding = {
              left = "0.3cell",
              right = "0.3cell",
              top = 0,
              bottom = 0,
            },

            tab_bar_at_bottom = true,
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
