{
  config,
  lib,
  inputs,
  host,
  pkgs,
  ...
}: let
  module = "_river";
  description = "dynamic tiling Wayland compositor";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;

  mode = "Alt";
  # resolution = "4096x2160";
  resolution = "3840x2160";
  # resolution = "2560x1440";
  #resolution = "1920x1080";
  menu = "${pkgs.bemenu}/bin/bemenu-run";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  # terminal = "'${pkgs.kitty}/bin/kitty -e ${pkgs.nushell}/bin/nu'";

  tags = builtins.genList (x: x) 9;
  tag_map_list =
    builtins.map (tag: {
      "${mode} ${toString (tag + 1)}" = "set-focused-tags ${toString tag}";
      "${mode}+Shift ${toString (tag + 1)}" = "set-view-tags ${toString tag}";
      "${mode}+Control ${toString (tag + 1)}" = "toggle-focused-tags ${toString tag}";
      "${mode}+Shift+Control ${toString (tag + 1)}" = "toggle-view-tags ${toString tag}";
    })
    tags;

  tag_map = builtins.foldl' (x: y: x // y) {} tag_map_list;
in {
  imports = [home-manager.nixosModules.home-manager];

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

    programs.river.enable = true;
    home-manager.users.${host.user} = {
      wayland.windowManager.river = {
        enable = true;
        settings = {
          border-width = 1;
          default-layout = "rivertile";
          declare-mode = ["locked" "normal" "passthrough"];
          map = {
            normal =
              {
                "${mode}+Shift Q" = "close";
                "${mode}+Shift E" = "exit";
                "${mode} F" = "toggle-fullscreen";
                "${mode} F11" = "enter-mode passthrough";

                "${mode} R" = "spawn ${menu}";
                "${mode} Return" = "spawn ${terminal}";

                # TODO: remove no-sandbox if could be run without root. no security at all
                "${mode} Q" = "spawn '${pkgs.qutebrowser}/bin/qutebrowser --no-sandbox'";
                "${mode} B" = "spawn '${pkgs.brave}/bin/brave --qt-flag no-sandbox'";

                #         "${mode} D" = "spawn ankama-launcher";
              }
              // tag_map;
            passthrough = {"${mode} F11" = "enter-mode normal";};
          };
          set-repeat = "50 300";
          spawn = [
            #  "${pkgs.brave}/bin/brave"
            #  "${pkgs.qutebrowser}/bin/qutebrowser"
            #  terminal
            "'${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode ${resolution} --scale 1.2'" # change scale for zoom 
            "'${pkgs.river}/bin/rivertile -view-padding 1 -outer-padding 3'"
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
