{ ... }:
let
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
        "brave"
        "kitty"
        "'wlr-randr --output WL-1 --custom-mode 1920x1080'"
        "'rivertile -view-padding 1 -outer-padding 3'"
        "swww-daemon"
        "'shuf -zen1 /srv/wallpapers/* | xargs -0 swww img'"
        "'eww daemon'"
        "'eww open-many clock'"
      ];

    };
  };
}
