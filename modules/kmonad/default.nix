{ ... }: {

  services.kmonad = {
    enable = true;
    # package = (builtins.getFlake github:kmonad/kmonad?dir=nix).rev  "1i4krl0m693iv85912v24zjxkyrf0xxvfgn5jmhnvy8fwv24v01l";
    keyboards = {
      hp = {
        device = "/dev/input/by-id/usb-CHICONY_HP_Basic_USB_Keyboard-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = true;

        };
        config = builtins.readFile ./colemak-dh_iso-100.kbd;
      };
    };
  };

}
