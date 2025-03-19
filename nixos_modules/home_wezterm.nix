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

        extraConfig = # lua
          ''
            local act = wezterm.action;
            return {
              line_height = 1.2,
              font_size = 8.7, -- 8.6 fixes ===

              bold_brightens_ansi_colors = "BrightAndBold",
              color_scheme = 'Catppuccin Mocha',

              window_padding = {
                left = "0.3cell",
                right = "0.3cell",
                top = "0.3cell",
                bottom = 0,
              },

              tab_bar_at_bottom = true,
              use_fancy_tab_bar = false,
              hide_tab_bar_if_only_one_tab = true,

              default_prog = { "nu" },

              keys = {
              -- Create a new workspace with a random name and switch to it
               {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
               { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
                -- Switch to the default workspace
              -- {
              --   key = 'd',
              --   mods = 'CTRL|SHIFT',
              --   action = "SwitchToWorkspace {
              --     name = 'default',
              --   }"
              -- },
              -- -- Switch to a monitoring workspace, which will have `top` launched into it
              -- {
              --   key = 'm',
              --   mods = 'CTRL|SHIFT',
              --   action = SwitchToWorkspace {
              --     name = 'monitoring',
              --     spawn = {
              --       args = { 'btm' },
              --     },
              --   },
              -- },
              -- {
              --   key = 'n',
              --   mods = 'CTRL|SHIFT',
              --   action = SwitchToWorkspace {
              --     name = 'notes',
              --     spawn = {
              --       cwd = '~/notes',
              --       args = { 'nvim' },
              --     },
              --   },
              -- },
              -- {
              --   key = 'd',
              --   mods = 'CTRL|SHIFT',
              --   action = SwitchToWorkspace {
              --     name = 'dotfiles',
              --     spawn = {
              --       cwd = '~/nixos',
              --       args = { 'nvim' },
              --     },
              --   },
              -- },
              -- -- Show the launcher in fuzzy selection mode and have it list all workspaces
              -- -- and allow activating one.
              -- {
              --   key = '9',
              --   mods = 'ALT',
              --   action = ShowLauncherArgs {
              --     flags = 'FUZZY|WORKSPACES',
              --   },
              -- },
              }

            }
          '';
      };
    };
  };
}
