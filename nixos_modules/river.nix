{
  config,
  lib,
  inputs,
  host,
  pkgs,
  ...
}:
let
  module = "_river";
  description = "dynamic tiling Wayland compositor";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;

  #   hint_activation_key: Activates hint mode. (default: A-M-x)
  #   hint2_activation_key: Activate two pass hint mode. (default: A-M-X)
  #   grid_activation_key: Activates grid mode and allows for further manipulation of the pointer using the mapped keys. (default: A-M-g)
  #   history_activation_key: Activate history mode. (default: A-M-h)
  #   screen_activation_key: Activate (s)creen selection mode. (default: A-M-s)
  #   activation_key: Activate normal movement mode (manual (c)ursor movement). (default: A-M-c)
  #   hint_oneshot_key: Activate hint mode and exit upon selection. (default: A-M-l)
  #   hint2_oneshot_key: Activate two pass hint mode and exit upon selection. (default: A-M-L)
  #   exit: Exit the currently active warpd session. (default: esc)
  #   drag: Toggle drag mode (mnemonic (v)isual mode). (default: v)
  #   copy_and_exit: Send the copy key and exit (useful in combination with v). (default: c)
  #   accelerator: Increase the acceleration of the pointer while held. (default: a)
  #   decelerator: Decrease the speed of the pointer while held. (default: d)
  #   buttons: A space separated list of mouse buttons (2 is middle click). (default: m , .)
  #   drag_button: The mouse buttton used for dragging. (default: 1)
  #   oneshot_buttons: Oneshot mouse buttons (deactivate on click). (default: n - /)
  #   print: Print the current mouse coordinates to stdout (useful for scripts). (default: p)
  #   history: Activate hint history mode while in normal mode. (default: ;)
  #   hint: Activate hint mode while in normal mode (mnemonic: x marks the spot?). (default: x)
  #   hint2: Activate two pass hint mode. (default: X)
  #   grid: Activate (g)rid mode while in normal mode. (default: g)
  #   screen: Activate (s)creen selection while in normal mode. (default: s)
  #   left: Move the cursor left in normal mode. (default: h)
  #   down: Move the cursor down in normal mode. (default: j)
  #   up: Move the cursor up in normal mode. (default: k)
  #   right: Move the cursor right in normal mode. (default: l)
  #   top: Moves the cursor to the top of the screen in normal mode. (default: H)
  #   middle: Moves the cursor to the middle of the screen in normal mode. (default: M)
  #   bottom: Moves the cursor to the bottom of the screen in normal mode. (default: L)
  #   start: Moves the cursor to the leftmost corner of the screen in normal mode. (default: 0)
  #   end: Moves the cursor to the rightmost corner of the screen in normal mode. (default: $)
  #   scroll_down: Scroll down key. (default: e)
  #   scroll_up: Scroll up key. (default: r)
  #   cursor_color: The color of the pointer in normal mode (rgba hex value). (default: #FF4500)
  #   cursor_size: The height of the pointer in normal mode. (default: 7)
  #   repeat_interval: The number of milliseconds before repeating a movement event. (default: 20)
  #   speed: Pointer speed in pixels/second. (default: 220)
  #   max_speed: The maximum pointer speed. (default: 1600)
  #   decelerator_speed: Pointer speed while decelerator is depressed. (default: 50)
  #   acceleration: Pointer acceleration in pixels/second^2. (default: 700)
  #   accelerator_acceleration: Pointer acceleration while the accelerator is depressed. (default: 2900)
  #   oneshot_timeout: The length of time in milliseconds to wait for a second click after a oneshot key has been pressed. (default: 300)
  #   hist_hint_size: History hint size as a percentage of screen height. (default: 2)
  #   grid_nr: The number of rows in the grid. (default: 2)
  #   grid_nc: The number of columns in the grid. (default: 2)
  #   hist_back: Move to the last position in the history stack. (default: C-o)
  #   hist_forward: Move to the next position in the history stack. (default: C-i)
  #   grid_up: Move the grid up. (default: w)
  #   grid_left: Move the grid left. (default: a)
  #   grid_down: Move the grid down. (default: s)
  #   grid_right: Move the grid right. (default: d)
  #   grid_keys: A sequence of comma delimited keybindings which are ordered bookwise with respect to grid position. (default: u i j k)
  #   grid_exit: Exit grid mode and return to normal mode. (default: c)
  #   grid_size: The thickness of grid lines in pixels. (default: 4)
  #   grid_border_size: The thickness of the grid border in pixels. (default: 0)
  #   grid_color: The color of the grid. (default: #1c1c1e)
  #   grid_border_color: The color of the grid border. (default: #ffffff)
  #   hint_bgcolor: The background hint color. (default: #1c1c1e)
  #   hint_fgcolor: The foreground hint color. (default: #a1aba7)
  #   hint_chars: The character set from which hints are generated. The total number of hints is the square of the size of this string. It may be desirable to increase this for larger screens or trim it to increase gaps between hints. (default: abcdefghijklmnopqrstuvwxyz)
  #   hint_font: The font name used by hints. Note: This is platform specific, in X it corresponds to a valid xft font name, on macos it corresponds to a postscript name. (default: Arial)
  #   hint_size: Hint size (range: 1-1000) (default: 20)
  #   hint_border_radius: Border radius. (default: 3)
  #   hint_exit: The exit key used for hint mode. (default: esc)
  #   hint_undo: undo last selection step in one of the hint based modes. (default: backspace)
  #   hint_undo_all: undo all selection steps in one of the hint based modes. (default: C-u)
  #   hint2_chars: The character set used for the second hint selection, should consist of at least hint_grid_size^2 characters. (default: hjkl;asdfgqwertyuiopzxcvb)
  #   hint2_size: The size of hints in the secondary grid (range: 1-1000). (default: 20)
  #   hint2_gap_size: The spacing between hints in the secondary grid. (range: 1-1000) (default: 1)
  #   hint2_grid_size: The size of the secondary grid. (default: 3)
  #   screen_chars: The characters used for screen selection. (default: jkl;asdfg)
  #   scroll_speed: Initial scroll speed in units/second (unit varies by platform). (default: 300)
  #   scroll_max_speed: Maximum scroll speed. (default: 9000)
  #   scroll_acceleration: Scroll acceleration in units/second^2. (default: 1600)
  #   scroll_deceleration: Scroll deceleration. (default: -3400)
  #   indicator: Specifies an optional visual indicator to be displayed while normal mode is active, must be one of: topright, topleft, bottomright, bottomleft, none (default: none)
  #   indicator_color: The color of the visual indicator color. (default: #00ff00)
  #   indicator_size: The size of the visual indicator in pixels. (default: 12)
  warpd_cfg = pkgs.writeText "warpd_cfg" ''
    left: i
    down: n
    up: u
    right: o
  '';

  warpd_wl =
    (pkgs.warpd.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "rvaiya";
        repo = "warpd";
        rev = "01650eabf70846deed057a77ada3c0bbb6d97d6e";
        sha256 = "sha256-61+kJvOi4oog0+tGucc1rWemdx2vp15wlluJE+1PzTs=";
      };
    }).override
      { withX = false; };

  mode = "Alt";
  # resolution = "4096x2160";
  resolution = "3840x2160";
  # resolution = "2560x1440";
  #resolution = "1920x1080";
  menu = "${pkgs.bemenu}/bin/bemenu-run";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  # terminal = "'${pkgs.kitty}/bin/kitty -e ${pkgs.nushell}/bin/nu'";

  # tags = builtins.genList (x: x) 9;
  # tag_map_list = builtins.map (tag: {
  #   "${mode}+Shift ${toString (tag + 1)}" = "set-view-tags ${toString tag}";
  #   "${mode}+Control ${toString (tag + 1)}" = "toggle-focused-tags ${toString tag}";
  #   "${mode}+Shift+Control ${toString (tag + 1)}" = "toggle-view-tags ${toString tag}";
  # }) tags;
  #
  # tag_map = builtins.foldl' (x: y: x // y) { } tag_map_list;
in
{
  imports = [ home-manager.nixosModules.home-manager ];

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

    programs.river-classic = {
      enable = true;
      xwayland.enable = false;
    };
    home-manager.users.${host.user} = {
      wayland.windowManager.river = {
        enable = true;
        settings = {
          border-width = 1;
          default-layout = "rivertile";
          declare-mode = [
            "locked"
            "normal"
            "passthrough"
          ];
          map = {
            normal = {
              # "${mode} F" = "spawn '${pkgs.warpd}/bin/warpd --hint'";
              # "${mode} M" = "spawn '${pkgs.warpd}/bin/warpd --normal'";
              "${mode} F" = "spawn '${warpd_wl}/bin/warpd --config ${warpd_cfg} --hint'";
              "${mode} M" = "spawn '${warpd_wl}/bin/warpd --config ${warpd_cfg} --normal'";

              # Layouts
              "${mode}+Control+Shift C" =
                "spawn '${pkgs.river-classic}/bin/riverctl keyboard-layout `us(colemak_dh_wide)`'";
              "${mode}+Control+Shift A" = "spawn '${pkgs.river-classic}/bin/riverctl keyboard-layout ara'";

              "${mode}+Shift Q" = "close";
              "${mode}+Shift E" = "exit";
              "${mode}+Shift F" = "toggle-fullscreen";
              "${mode} F11" = "enter-mode passthrough";

              "${mode} R" = "spawn ${menu}";
              "${mode} Return" = "spawn '${pkgs.wezterm}/bin/wezterm start --always-new-process'";

              "${mode} Q" = "spawn ${pkgs.qutebrowser}/bin/qutebrowser";
              "${mode} B" = "spawn ${pkgs.brave}/bin/brave";
              "${mode} C" =
                "spawn '${pkgs.ungoogled-chromium}/bin/chromium --incognito --enable-experimental-web-platform-features --auto-open-devtools-for-tabs http://127.0.0.1:8080'";

              #         "${mode} D" = "spawn ankama-launcher";

              # Tags
              # not bit shifting operators https://github.com/NixOS/nix/pull/13001
              "${mode}  1" = "set-focused-tags 1";
              "${mode}  2" = "set-focused-tags 10";
              "${mode}  3" = "set-focused-tags 100";
              "${mode}  4" = "set-focused-tags 1000";
              "${mode}  5" = "set-focused-tags 10000";
              "${mode}  6" = "set-focused-tags 100000";
              "${mode}  7" = "set-focused-tags 1000000";
              "${mode}  8" = "set-focused-tags 10000000";
              "${mode}  9" = "set-focused-tags 100000000";
              "${mode}  0" = "set-focused-tags 111111111";

              "${mode}+Shift 1" = "set-view-tags 1";
              "${mode}+Shift 2" = "set-view-tags 10";
              "${mode}+Shift 3" = "set-view-tags 100";
              "${mode}+Shift 4" = "set-view-tags 1000";
              "${mode}+Shift 5" = "set-view-tags 10000";
              "${mode}+Shift 6" = "set-view-tags 100000";
              "${mode}+Shift 7" = "set-view-tags 1000000";
              "${mode}+Shift 8" = "set-view-tags 10000000";
              "${mode}+Shift 9" = "set-view-tags 100000000";
              "${mode}+Shift 0" = "set-view-tags 111111111";

              "${mode}+Control 1" = "toggle-focused-tags 1";
              "${mode}+Control 2" = "toggle-focused-tags 10";
              "${mode}+Control 3" = "toggle-focused-tags 100";
              "${mode}+Control 4" = "toggle-focused-tags 1000";
              "${mode}+Control 5" = "toggle-focused-tags 10000";
              "${mode}+Control 6" = "toggle-focused-tags 100000";
              "${mode}+Control 7" = "toggle-focused-tags 1000000";
              "${mode}+Control 8" = "toggle-focused-tags 10000000";
              "${mode}+Control 9" = "toggle-focused-tags 100000000";
              "${mode}+Control 0" = "toggle-focused-tags 111111111";

              "${mode}+Shift+Control 1" = "toggle-view-tags 1";
              "${mode}+Shift+Control 2" = "toggle-view-tags 10";
              "${mode}+Shift+Control 3" = "toggle-view-tags 100";
              "${mode}+Shift+Control 4" = "toggle-view-tags 1000";
              "${mode}+Shift+Control 5" = "toggle-view-tags 10000";
              "${mode}+Shift+Control 6" = "toggle-view-tags 100000";
              "${mode}+Shift+Control 7" = "toggle-view-tags 1000000";
              "${mode}+Shift+Control 8" = "toggle-view-tags 10000000";
              "${mode}+Shift+Control 9" = "toggle-view-tags 100000000";
              "${mode}+Shift+Control 0" = "toggle-view-tags 111111111";
            };
            # // tag_map;
            passthrough = {
              "${mode} F11" = "enter-mode normal";
            };
          };

          set-repeat = "50 300";
          keyboard-layout = "-options 'grp:alt_space_toggle' 'us(colemak_dh_wide),ara'";

          spawn = [
            #  "${pkgs.brave}/bin/brave"
            #  "${pkgs.qutebrowser}/bin/qutebrowser"
            #  terminal
            "'${pkgs.coreutils}/bin/rm -f /home/${host.user}/.config/BraveSoftware/Brave-Browser/Singleton* /home/${host.user}/.config/chromium/Singleton*'" # fixs brave profile appears to be in use by another process. due to changing of hostname inside docker containers
            "'${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode ${resolution} --scale 1.3'" # change scale for zoom
            "'${pkgs.river-classic}/bin/rivertile -view-padding 1 -outer-padding 3'"
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
