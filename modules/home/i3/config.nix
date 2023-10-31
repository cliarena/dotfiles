{ ... }:
# builtins.toFile "config" ''

''
    # This file has been auto-generated by i3-config-wizard(1).
    # It will not be overwritten, so edit it as you like.
    #
    # Should you change your keyboard layout some time, delete
    # this file and re-run i3-config-wizard(1).
    #

    # i3 config file (v4)
    #
    # Please see https://i3wm.org/docs/userguide.html for a complete reference!

    set $mod Mod1

    # Font for window titles. Will also be used by the bar unless a different font
    # is used in the bar {} block below.
    font pango:JetBrainsMono nerd font

    # This font is widely installed, provides lots of unicode glyphs, right-to-left
    # text rendering and scalability on retina/hidpi displays (thanks to pango).
    #font pango:DejaVu Sans Mono 8

    # Start XDG autostart .desktop files using dex. See also
    # https://wiki.archlinux.org/index.php/XDG_Autostart
    exec --no-startup-id dex --autostart --environment i3

    # The combination of xss-lock, nm-applet and pactl is a popular choice, so
    # they are included here as an example. Modify as you see fit.

    # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
    # screen before suspend. Use loginctl lock-session to lock your screen.
    exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

    # Auto start apps
    exec --no-startup-id kitty
    exec --no-startup-id kitty
    # --user-data-dir=$(mktemp -d) to open new instance not just a new window needed to open devtools in one instance not the other
    exec --no-startup-id chromium-browser http://0.0.0.0:3000 --user-data-dir=$(mktemp -d) --auto-open-devtools-for-tabs --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-drdc --canvas-oop-rasterization --ui-enabe-shared-image-cache-for-gpu --use-gpu-scheduler-dfs
    exec --no-startup-id chromium-browser --app=http://0.0.0.0:3000 --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-drdc --canvas-oop-rasterization --ui-enabe-shared-image-cache-for-gpu --use-gpu-scheduler-dfs

  # Workspaces layouts
    # put the workspace you want to face at last to get focus
    exec --no-startup-id "i3-msg 'workspace 2; append_layout ${
      import ./workspace-2.nix { }
    }'"
    exec --no-startup-id "i3-msg 'workspace 1; append_layout ${
      import ./workspace-1.nix { }
    }'"



    # Use pactl to adjust volume in PulseAudio.
    set $refresh_i3status killall -SIGUSR1 i3status
    
    
    
    

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # move tiling windows via drag & drop by left-clicking into the title bar,
    # or left-clicking anywhere into the window while holding the floating modifier.
    tiling_drag modifier titlebar

    # Hide title bar
    default_border pixel 1
    default_floating_border pixel 1

    # start a terminal
    
    # kill focused window
    

    # start dmenu (a program launcher)
    
    # A more modern dmenu replacement is rofi:
    # bindcode $mod+40 exec "rofi -modi drun,run -show drun"
    # There also is i3-dmenu-desktop which only displays applications shipping a
    # .desktop file. It is a wrapper around dmenu, so you need that installed.
    # bindcode $mod+40 exec --no-startup-id i3-dmenu-desktop

    # change focus
    
    
    
    

    # alternatively, you can use the cursor keys:
    
    
    
    

    # move focused window
    
    
    
    

    # alternatively, you can use the cursor keys:
    
    
    
    

    # split in horizontal orientation
    

    # split in vertical orientation
    

    # enter fullscreen mode for the focused container
    

    # change container layout (stacked, tabbed, toggle split)
    
    
    

    # toggle tiling / floating
    

    # change focus between tiling / floating windows
    

    # focus the parent container
    

    # focus the child container
    #

    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    # switch to workspace
    
    
    
    
    
    
    
    
    
    

    # move focused container to workspace
    
    
    
    
    
    
    
    
    
    

    # reload the configuration file
    
    # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
    
    # exit i3 (logs you out of your X session)
    

    # resize window (you can also use the mouse for that)
    mode "resize" {
            # These bindings trigger as soon as you enter the resize mode

            # Pressing left will shrink the window’s width.
            # Pressing right will grow the window’s width.
            # Pressing up will shrink the window’s height.
            # Pressing down will grow the window’s height.
            
            
            
            

            # same bindings, but for the arrow keys
            
            
            
            

            # back to normal: Enter or Escape or $mod+r
            
            
            
    }

    

    # Start i3bar to display a workspace bar (plus the system information i3status
    # finds out, if available)
    bar {
        mode invisible
        hidden_state hide
        modifier Mod1
        status_command i3status
    }
''
