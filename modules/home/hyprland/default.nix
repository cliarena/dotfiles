{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = { enable = true; };
    extraConfig = builtins.foldl' (x: y: builtins.readFile y + x) "" [
      ./binds.conf
      ./rules.conf
      ./theme.conf
      ./settings.conf
    ];
  };
}
