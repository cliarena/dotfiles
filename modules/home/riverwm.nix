{ ... }: {
  wayland.windowManager.river = {
    enable = true;
    settings = {
      border-width = 2;
      declare-mode = [ "locked" "normal" "passthrough" ];
      map = { normal = { "Alt Q" = "close"; }; };
      set-repeat = "50 300";
      spawn = [ "brave" ];
    };
  };
}
