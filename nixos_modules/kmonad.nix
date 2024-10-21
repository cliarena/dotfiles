{ config, lib, inputs, ... }:
let
  module = "_kmonad";
  description = "keyboard layouts for any keyboard";
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [ inputs.kmonad.nixosModules.default ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    services.kmonad = {
      enable = true;
      keyboards = {
        hp = {
          device =
            "/dev/input/by-id/usb-CHICONY_HP_Basic_USB_Keyboard-event-kbd";
          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = true;

          };
          config = ''
            (defalias
              ext  (layer-toggle extend) ;; Bind 'ext' to the Extend Layer
              sym  (layer-switch symbols) ;; Bind 'sym' to Symbols Layer
              dh  (layer-switch colemak-dh) ;; Bind 'sym' to Symbols Layer
            )

            (defalias
              cpy C-c
              pst C-v
              cut C-x
              udo C-z
              all C-a
              fnd C-f
              bk Back
              fw Forward
              £ S-3  ;;UK pound sign
            )

            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    ret   del  end  pgdn  kp7  kp8  kp9  kp+
              caps a    s    d    f    g    h    j    k    l    ;    '    \                          kp4  kp5  kp6
              lsft 102d z    x    c    v    b    n    m    ,    .    /    rsft            up         kp1  kp2  kp3  kprt
              lctl lmet lalt           spc                 ralt rmet cmp  rctl       left down rght  kp0  kp.
            )

            (deflayer colemak-dh
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
               _   1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
              @sym q    w    f    p    b    j    l    u    y    ;    [    ]    ret   del  end  pgdn  kp7  kp8  kp9  kp+
              @ext a    r    s    t    g    m    n    e    i    o    '    \                          kp4  kp5  kp6
              lsft z    x    c    d    v  102d   k    h    ,    .    /  rsft              up         kp1  kp2  kp3  kprt
              lctl lmet lalt           spc                 _ rmet cmp  rctl       left down rght  kp0  kp.
            )

            (deflayer extend
              _   play rewind previoussong nextsong ejectcd refresh brdn brup   www   mail   prog1  prog2        _    _    _
              _   f1    f2       f3          f4       f5      f6     f7   f8    f9    f10     f11   f12   bspc   _    _    _    _    _    _    _
              _   esc   @bk      @fnd        @fw      ins    pgup   home  up    end   menu   prnt   slck  ret    _    _    _    _    _    _    _
              _   @all  tab      lsft        lctl     lalt   pgdn   lft  down   rght  del    caps   _                           _    _    _
              _   @udo  @cut     @cpy        @pst     @pst    _     pgdn  bks   f13   f14    comp   _                 _         _    _    _    _
              _        _    _              ret            _    _    _    _                                       _    _    _    _    _
            )

            (deflayer symbols
              _   _    _    _    _    _    _    _    _    _    _    _    _           _    _    _
              _   _    _    _    _    _    _    _    _    _    _    _    _    _      _    _    _    _    _    _    _
             @dh  S-1  S-2  S-3  S-4  S-5  =    7    8    9    +    «    »    _      _    _    _    _    _    _    _
             @ext \_   [    {    \(   S-6  *    4    5    6    0    -    _                          _    _    _
              _   #    ]    }    \)   S-7  `    1    2    3    _    /    _               _          _    _    _    _
              _    _    _                _                _    _    _    _          _    _    _     _    _
            )

            (deflayer empty
              _    _    _    _    _    _    _    _    _    _    _    _    _          _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _     _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _     _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _                         _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _               _         _    _    _    _
              _    _    _              _                   _    _    _    _          _    _    _    _    _
            )'';
        };
      };
    };

  };
}
