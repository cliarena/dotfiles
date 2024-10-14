{ config, lib, inputs, host, ... }:
let
  module = "_hyprland";
  description = "dynamic tiling window manager";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager hyprland;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.hyprland.enable = true;

    home-manager.users.${host.user} = {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland = { enable = true; };
        extraConfig = ''
          # EWW
          bind = CTRL SHIFT, R, exec, bash ~/.config/eww/scripts/init

          # Print
          bind = , Print,exec, distrobox-enter -n Arch -- hyprshot -m region -o $HOME/Pictures/Screenshots
          bind = SHIFT, Print,exec, distrobox-enter -n Arch -- hyprshot -m output -o $HOME/Pictures/Screenshots

          # Lid
          bindl= , switch:on:Lid Switch, exec, bash ~/.config/eww/scripts/launcher screenlock

          # Launchers
          bind = SUPER, Return, exec, kitty
          bind = SUPER, W, exec, chromium
          bind = SUPER, B, exec, brave
          bind = SUPER, P, exec, pavucontrol
          bind = SUPER, E, exec, nautilus
          bind = SUPER, R, exec, bash ~/.config/eww/scripts/launcher toggle_menu app_launcher

          # Bindings
          bind = CTRL ALT, Delete, exit
          bind = ALT, Q, killactive
          bind = SUPER, F, togglefloating
          bind = SUPER, H, fullscreenstate, 0 2
          bind = SUPER, G, fullscreen
          bind = SUPER, J, togglesplit

          # Move focus with mainMod + arrow keys
          bind = SUPER, u, movefocus, u
          bind = SUPER, e, movefocus, d
          bind = SUPER, i, movefocus, r
          bind = SUPER, n, movefocus, l

          # Switch workspaces with mainMod + [0-9]
          bind = SUPER, left,   workspace, e-1
          bind = SUPER, right, workspace, e+1
          bind = SUPER, 1, workspace, 1
          bind = SUPER, 2, workspace, 2
          bind = SUPER, 3, workspace, 3
          bind = SUPER, 4, workspace, 4
          bind = SUPER, 5, workspace, 5
          bind = SUPER, 6, workspace, 6
          bind = SUPER, 7, workspace, 7
          bind = SUPER, 8, workspace, 8
          bind = SUPER, 9, workspace, 9

          # Window
          binde = SUPER CTRL, k, resizeactive, 0 -20
          binde = SUPER CTRL, j, resizeactive, 0 20
          binde = SUPER CTRL, l, resizeactive, 20 0
          binde = SUPER CTRL, h, resizeactive, -20 0
          binde = SUPER ALT,  k, moveactive, 0 -20
          binde = SUPER ALT,  j, moveactive, 0 20
          binde = SUPER ALT,  l, moveactive, 20 0
          binde = SUPER ALT,  h, moveactive, -20 0

          # Move active window to workspace
          bind = SUPER SHIFT, right, movetoworkspace, e+1
          bind = SUPER SHIFT, left,  movetoworkspace, e-1
          bind = SUPER SHIFT, 1, movetoworkspace, 1
          bind = SUPER SHIFT, 2, movetoworkspace, 2
          bind = SUPER SHIFT, 3, movetoworkspace, 3
          bind = SUPER SHIFT, 4, movetoworkspace, 4
          bind = SUPER SHIFT, 5, movetoworkspace, 5
          bind = SUPER SHIFT, 6, movetoworkspace, 6
          bind = SUPER SHIFT, 7, movetoworkspace, 7
          bind = SUPER SHIFT, 8, movetoworkspace, 8
          bind = SUPER SHIFT, 9, movetoworkspace, 9

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = SUPER, mouse:272, movewindow
          bindm = SUPER, mouse:273, resizewindow

          # Laptop
          bindle = , XF86MonBrightnessUp,     exec, bash ~/.config/eww/scripts/brightness screen up
          bindle = , XF86MonBrightnessDown,   exec, bash ~/.config/eww/scripts/brightness screen down
          bindle = , XF86KbdBrightnessUp,     exec, bash ~/.config/eww/scripts/brightness kbd up
          bindle = , XF86KbdBrightnessDown,   exec, bash ~/.config/eww/scripts/brightness kbd down
          bindle = , XF86AudioRaiseVolume,    exec, bash ~/.config/eww/scripts/volume up
          bindle = , XF86AudioLowerVolume,    exec, bash ~/.config/eww/scripts/volume down
          bindl  = , XF86AudioStop,           exec, playerctl stop
          bindl  = , XF86AudioPause,          exec, playerctl pause
          bindl  = , XF86AudioPrev,           exec, playerctl previous
          bindl  = , XF86AudioNext,           exec, playerctl next

          windowrule = float, ^(Rofi)$
          windowrule = float, ^(org.gnome.Calculator)$
          windowrule = float, ^(org.gnome.Nautilus)$
          windowrule = float, ^(eww)$
          windowrule = float, ^(pavucontrol)$
          windowrule = float, ^(nm-connection-editor)$
          windowrule = float, ^(blueberry.py)$
          windowrule = float, ^(org.gnome.Settings)$
          windowrule = float, ^(org.gnome.design.Palette)$
          windowrule = float, ^(Color Picker)$
          windowrule = float, ^(Network)$
          windowrule = float, ^(xdg-desktop-portal)$
          windowrule = float, ^(xdg-desktop-portal-gnome)$
          windowrule = float, ^(transmission-gtk)$

          general {
            layout = dwindle
          }

          input {
          #  kb_layout = hu
          #  kb_model = pc104
            follow_mouse = 3
            touchpad {
              natural_scroll = true
            }
            sensitivity = 0
          }

          binds {
            allow_workspace_cycles = true
          }

          dwindle {
            default_split_ratio = 1.6
            pseudotile = true
            preserve_split = true
            force_split = 2
          # no_gaps_when_only = true
          }

          gestures {
            workspace_swipe = on
          }

          # Fix slow app startup
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

          monitor=,preferred,auto,1

          general {
            gaps_in = 2
            gaps_out = 2,6,2,6
            border_size = 1
            col.active_border = rgba(51a4e766)
            col.inactive_border = rgb(2a2a2a)
          }

          decoration {
            rounding = 8
            blur {
              enabled = true
              size = 2
              passes = 1
              new_optimizations = true
            }

            drop_shadow = true
            shadow_range = 8
            shadow_render_power = 2
            col.shadow = rgba(00000044)

            dim_inactive = false
          }

          animations {
            enabled = false
            bezier = myBezier, 0.05, 0.9, 0.1, 1.05
            animation = windows, 1, 5, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
          }
        '';
      };
    };
  };

}
