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
          # builtins.map (tag: )
        } // tag_map;
        # normal = { "Super $tag" = "set-focused-tags $tag + 1"; };

      };
      # Super+[1-9] to focus tag [0-8]
      # riverctl map normal Super $i set-focused-tags $tags
      # # Super+Shift+[1-9] to tag focused view with tag [0-8]
      # riverctl map normal Super+Shift $i set-view-tags $tags
      # # Super+Control+[1-9] to toggle focus of tag [0-8]
      # riverctl map normal Super+Control $i toggle-focused-tags $tags
      # # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
      # riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      set-repeat = "50 300";
      spawn = [ "brave" "kitty" ];
    };
  };
}
