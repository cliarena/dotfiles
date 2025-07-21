{...}: {
  xsession.windowManager.i3 = {
    enable = true;
    extraConfig = import ./config.nix {};
  };
}
