{...}:{
    programs.kitty = {
        enable = true;
        font = {
            # name = "FiraCode Nerd Font Mono";
            name = "JetBrainsMono nerd font";
            size = 9;
          };
        theme = "Catppuccin-Mocha";
        extraConfig = ''
          adjust_line_height 120%
          tab_bar_style powerline
          tab_powerline_style round
          wayland_titlebar_color background       
          '';
      };
  }
