{ config, lib, inputs, host, pkgs, ... }:
let
  module = "_river";
  description = "dynamic tiling Wayland compositor";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;

  tags = builtins.genList (x: x) 9;
  tag_map_list = builtins.map (tag: {
    "Alt ${toString (tag + 1)}" = "set-focused-tags ${toString tag}";
    "Alt+Shift ${toString (tag + 1)}" = "set-view-tags ${toString tag}";
    "Alt+Control ${toString (tag + 1)}" = "toggle-focused-tags ${toString tag}";
    "Alt+Shift+Control ${toString (tag + 1)}" =
      "toggle-view-tags ${toString tag}";
  }) tags;

  tag_map = builtins.foldl' (x: y: x // y) { } tag_map_list;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.river.enable = true;
    home-manager.users.${host.user} = {
      wayland.windowManager.river = {
        enable = true;
        settings = {
          border-width = 1;
          default-layout = "rivertile";
          declare-mode = [ "locked" "normal" "passthrough" ];
          map = {
            normal = {
              "Alt Q" = "close";
              "Alt F" = "toggle-fullscreen";
              "Alt F11" = "enter-mode passthrough";
            } // tag_map;
            passthrough = { "Alt F11" = "enter-mode normal"; };
          };
          set-repeat = "50 300";
          spawn = [
            "${pkgs.brave}/bin/brave"
            "'${pkgs.kitty}/bin/kitty -e ${pkgs.nushell}/bin/nu'"
            "'${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode 1920x1080'"
            "'${pkgs.river}/bin/rivertile -view-padding 1 -outer-padding 3'"
            "${pkgs.swww}/bin/swww-daemon"
            "'${pkgs.coreutils}/bin/shuf -zen1 /srv/wallpapers/* | ${pkgs.findutils}/bin/xargs -0 ${pkgs.swww}/bin/swww img'"
            "'${pkgs.eww}/bin/eww daemon'"
            "'${pkgs.eww}/bin/eww open-many clock'"
          ];
        };
      };
    };
  };
}
