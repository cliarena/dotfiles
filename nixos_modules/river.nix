{
  config,
  lib,
  inputs,
  host,
  pkgs,
  ...
}:
let
  module = "_river";
  description = "dynamic tiling Wayland compositor";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;

  warpd_wl =
    (pkgs.warpd.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "rvaiya";
        repo = "warpd";
        rev = "01650eabf70846deed057a77ada3c0bbb6d97d6e";
        sha256 = "sha256-61+kJvOi4oog0+tGucc1rWemdx2vp15wlluJE+1PzTs=";
      };
    }).override
      { withX = false; };

  mode = "Alt";
  # resolution = "4096x2160";
  resolution = "3840x2160";
  # resolution = "2560x1440";
  #resolution = "1920x1080";
  menu = "${pkgs.bemenu}/bin/bemenu-run";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  # terminal = "'${pkgs.kitty}/bin/kitty -e ${pkgs.nushell}/bin/nu'";

  # tags = builtins.genList (x: x) 9;
  # tag_map_list = builtins.map (tag: {
  #   "${mode}+Shift ${toString (tag + 1)}" = "set-view-tags ${toString tag}";
  #   "${mode}+Control ${toString (tag + 1)}" = "toggle-focused-tags ${toString tag}";
  #   "${mode}+Shift+Control ${toString (tag + 1)}" = "toggle-view-tags ${toString tag}";
  # }) tags;
  #
  # tag_map = builtins.foldl' (x: y: x // y) { } tag_map_list;
in
{
  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    #   services.greetd = {
    #    enable =true;
    #    settings = rec {
    #      initial_session = {
    #        command = "${pkgs.sway}/bin/sway";
    #        user = host.user;
    #      };
    #      default_session = initial_session;

    #};
    #};

    programs.river-classic = {
      enable = true;
      xwayland.enable = false;
    };
    home-manager.users.${host.user} = {
      wayland.windowManager.river = {
        enable = true;
        settings = {
          border-width = 1;
          default-layout = "rivertile";
          declare-mode = [
            "locked"
            "normal"
            "passthrough"
          ];
          map = {
            normal = {
              # "${mode} F" = "spawn '${pkgs.warpd}/bin/warpd --hint'";
              # "${mode} M" = "spawn '${pkgs.warpd}/bin/warpd --normal'";
              "${mode} F" = "spawn '${warpd_wl}/bin/warpd --hint'";
              "${mode} M" = "spawn '${warpd_wl}/bin/warpd --normal'";

              # Layouts
              "${mode}+Control+Shift C" =
                "spawn '${pkgs.river-classic}/bin/riverctl keyboard-layout `us(colemak_dh_wide)`'";
              "${mode}+Control+Shift A" = "spawn '${pkgs.river-classic}/bin/riverctl keyboard-layout ara'";

              "${mode}+Shift Q" = "close";
              "${mode}+Shift E" = "exit";
              "${mode}+Shift F" = "toggle-fullscreen";
              "${mode} F11" = "enter-mode passthrough";

              "${mode} R" = "spawn ${menu}";
              "${mode} Return" = "spawn '${pkgs.wezterm}/bin/wezterm start --always-new-process'";

              "${mode} Q" = "spawn ${pkgs.qutebrowser}/bin/qutebrowser";
              "${mode} B" = "spawn ${pkgs.brave}/bin/brave";
              "${mode} C" =
                "spawn '${pkgs.ungoogled-chromium}/bin/chromium --incognito --enable-experimental-web-platform-features --auto-open-devtools-for-tabs http://127.0.0.1:8080'";

              #         "${mode} D" = "spawn ankama-launcher";

              # Tags
              # not bit shifting operators https://github.com/NixOS/nix/pull/13001
              "${mode}  1" = "set-focused-tags 1";
              "${mode}  2" = "set-focused-tags 10";
              "${mode}  3" = "set-focused-tags 100";
              "${mode}  4" = "set-focused-tags 1000";
              "${mode}  5" = "set-focused-tags 10000";
              "${mode}  6" = "set-focused-tags 100000";
              "${mode}  7" = "set-focused-tags 1000000";
              "${mode}  8" = "set-focused-tags 10000000";
              "${mode}  9" = "set-focused-tags 100000000";
              "${mode}  0" = "set-focused-tags 111111111";

              "${mode}+Shift 1" = "set-view-tags 1";
              "${mode}+Shift 2" = "set-view-tags 10";
              "${mode}+Shift 3" = "set-view-tags 100";
              "${mode}+Shift 4" = "set-view-tags 1000";
              "${mode}+Shift 5" = "set-view-tags 10000";
              "${mode}+Shift 6" = "set-view-tags 100000";
              "${mode}+Shift 7" = "set-view-tags 1000000";
              "${mode}+Shift 8" = "set-view-tags 10000000";
              "${mode}+Shift 9" = "set-view-tags 100000000";
              "${mode}+Shift 0" = "set-view-tags 111111111";

              "${mode}+Control 1" = "toggle-focused-tags 1";
              "${mode}+Control 2" = "toggle-focused-tags 10";
              "${mode}+Control 3" = "toggle-focused-tags 100";
              "${mode}+Control 4" = "toggle-focused-tags 1000";
              "${mode}+Control 5" = "toggle-focused-tags 10000";
              "${mode}+Control 6" = "toggle-focused-tags 100000";
              "${mode}+Control 7" = "toggle-focused-tags 1000000";
              "${mode}+Control 8" = "toggle-focused-tags 10000000";
              "${mode}+Control 9" = "toggle-focused-tags 100000000";
              "${mode}+Control 0" = "toggle-focused-tags 111111111";

              "${mode}+Shift+Control 1" = "toggle-view-tags 1";
              "${mode}+Shift+Control 2" = "toggle-view-tags 10";
              "${mode}+Shift+Control 3" = "toggle-view-tags 100";
              "${mode}+Shift+Control 4" = "toggle-view-tags 1000";
              "${mode}+Shift+Control 5" = "toggle-view-tags 10000";
              "${mode}+Shift+Control 6" = "toggle-view-tags 100000";
              "${mode}+Shift+Control 7" = "toggle-view-tags 1000000";
              "${mode}+Shift+Control 8" = "toggle-view-tags 10000000";
              "${mode}+Shift+Control 9" = "toggle-view-tags 100000000";
              "${mode}+Shift+Control 0" = "toggle-view-tags 111111111";
            };
            # // tag_map;
            passthrough = {
              "${mode} F11" = "enter-mode normal";
            };
          };

          set-repeat = "50 300";
          keyboard-layout = "-options 'grp:alt_space_toggle' 'us(colemak_dh_wide),ara'";

          spawn = [
            #  "${pkgs.brave}/bin/brave"
            #  "${pkgs.qutebrowser}/bin/qutebrowser"
            #  terminal
            "'${pkgs.coreutils}/bin/rm -f /home/${host.user}/.config/BraveSoftware/Brave-Browser/Singleton* /home/${host.user}/.config/chromium/Singleton*'" # fixs brave profile appears to be in use by another process. due to changing of hostname inside docker containers
            "'${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode ${resolution} --scale 1.3'" # change scale for zoom
            "'${pkgs.river-classic}/bin/rivertile -view-padding 1 -outer-padding 3'"
            "'${pkgs.coreutils}/bin/shuf -zen1 /srv/library/wallpapers/* | ${pkgs.findutils}/bin/xargs -0 ${pkgs.wbg}/bin/wbg'"
            #  "'${pkgs.coreutils}/bin/shuf -zen1 /srv/wallpapers/* | ${pkgs.findutils}/bin/xargs -0 ${pkgs.swww}/bin/swww img'"
            #  "${pkgs.swww}/bin/swww-daemon"
            #  "'${pkgs.eww}/bin/eww daemon'"
            #  "'${pkgs.eww}/bin/eww open-many clock'"
          ];
        };
      };
    };
  };
}
