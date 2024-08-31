{ ... }: {
  wayland.windowManager.river = {
    enable = true;
    settings = {
      border-width = 1;
      default-layout = "rivertile";
      declare-mode = [ "locked" "normal" "passthrough" ];
      map = { normal = { "Alt Q" = "close"; }; };
      set-repeat = "50 300";
      spawn = [ "brave" "kitty" ];
    };
  };
}
