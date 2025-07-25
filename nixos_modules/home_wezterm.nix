{
  config,
  lib,
  pkgs,
  inputs,
  host,
  ...
}: let
  module = "_home_wezterm";
  description = "wezterm config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {
  imports = [home-manager.nixosModules.home-manager];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    home-manager.users.${host.user} = {
      programs.wezterm = {
        enable = true;

        extraConfig =
          # lua
          ''
            local act = wezterm.action

            local function is_vim(pane)
              -- this is set by the plugin, and unset on ExitPre in Neovim
              return pane:get_user_vars().IS_NVIM == 'true'
            end

            local direction_keys = {
              LeftArrow = 'Left',
              DownArrow = 'Down',
              UpArrow = 'Up',
              RightArrow = 'Right',
            }

            local function split_nav(resize_or_move, key)
              return {
                key = key,
                mods = resize_or_move == 'resize' and 'ALT' or 'CTRL',
                action = wezterm.action_callback(function(win, pane)
                  if is_vim(pane) then
                    -- pass the keys through to vim/nvim
                    win:perform_action({
                      SendKey = { key = key, mods = resize_or_move == 'resize' and 'ALT' or 'CTRL' },
                    }, pane)
                  else
                    if resize_or_move == 'resize' then
                      win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                    else
                      win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                    end
                  end
                end),
              }
            end

            -- this is called by the mux server when it starts up.
            -- It makes a window split top/bottom
            -- wezterm.on('mux-startup', function()
            --   local tab, pane, window = wezterm.mux.spawn_window {}
            --   pane:split { direction = 'Top' }
            -- end)

            return {
              -- leader = { key = 'Space', mods = "" },
              line_height = 1.2,
              font_size = 8.7, -- 8.6 fixes ===
              font = wezterm.font('JetBrains Mono', { weight = 'DemiBold' }),

              bold_brightens_ansi_colors = "BrightAndBold",
              color_scheme = 'Catppuccin Mocha',

              window_padding = {
                left = "0.3cell",
                right = "0.3cell",
                top = "0.3cell",
                bottom = 0,
              },

              enable_tab_bar = false,
              tab_bar_at_bottom = true,
              use_fancy_tab_bar = false,
              hide_tab_bar_if_only_one_tab = true,

            --  default_prog = { "${pkgs.nushell}/bin/nu" },

              set_environment_variables = { PATH = os.getenv 'PATH', },

              keys = {
              -- Create a new workspace with a random name and switch to it
               -- { key = 's', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = "CurrentPaneDomain"} },
               -- { key = 'h', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = "CurrentPaneDomain"} },
               { key = 's', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right', size = { Percent = 24 },}, },
               { key = 'h', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down', size = { Percent = 24 },}, },
               { key = 'q', mods = 'ALT|SHIFT', action = act.CloseCurrentPane { confirm = false } },

               { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },

                -- move between split panes
                split_nav('move', 'LeftArrow'),
                split_nav('move', 'DownArrow'),
                split_nav('move', 'UpArrow'),
                split_nav('move', 'RightArrow'),
                -- resize panes
                split_nav('resize', 'LeftArrow'),
                split_nav('resize', 'DownArrow'),
                split_nav('resize', 'UpArrow'),
                split_nav('resize', 'RightArrow'),
                -- Switch to the default workspace
              {
                key = 'd',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'default',
                }
              },
              -- Switch to a monitoring workspace, which will have `top` launched into it
            --  {
            --    key = 'F1',
            --    mods = 'CTRL|SHIFT',
            --    action = act.SwitchToWorkspace {
            --     name = 'SVR',
            --      spawn = {
            --        -- args = { 'nu' },
            --        domain = { DomainName = 'SSHMUX:SVR' },
            --      },
            --    },
            --  },
              {
                key = 'm',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'monitoring',
                  spawn = {
                    args = { 'btm' },
            --        domain = { DomainName = 'SSHMUX:DS' },
                  },
                },
              },
              {
                key = 'n',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'notes',
                  spawn = {
                    cwd = '/home/x/notes',
                    args = { 'nvim' },
             --       domain = { DomainName = 'SSHMUX:DS' },
                  },
                },
              },
              {
                key = 'd',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'dotfiles',
                  spawn = {
                    cwd = '/home/x/dotfiles',
                    args = { 'nvim' },
             --       domain = { DomainName = 'SSHMUX:DS' },
                  },
                },
              },
              {
                key = 'F10',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'project_main',
                  spawn = {
                    cwd = '/home/x/project_main',
                    args = { 'nvim' },
             --       domain = { DomainName = 'SSHMUX:DS' },
                  },
                },
              },
              {
                key = 'F11',
                mods = 'CTRL|SHIFT',
                action = act.SwitchToWorkspace {
                  name = 'project_secondary',
                  spawn = {
                    cwd = '/home/x/project_secondary',
                    args = { 'nvim' },
             --       domain = { DomainName = 'SSHMUX:DS' },
                  },
                },
              },
              -- {
              --   key = 'F1',
              --   mods = 'CTRL|SHIFT',
              --   action = act.SwitchToWorkspace {
              --     name = 'local',
              --     spawn = {
              --       cwd = '/home/x',
              --       -- args = { 'nvim' },
              --       -- domain = { DomainName = 'SSHMUX:DS' },
              --     },
              --   },
              -- },
              -- Show the launcher in fuzzy selection mode and have it list all workspaces
              -- and allow activating one.
              {
                key = 'f',
                mods = 'CTRL|SHIFT',
                action = act.ShowLauncherArgs {
                  flags = 'FUZZY|WORKSPACES',
                  },
                },
              }

            }
          '';
      };
    };
  };
}
