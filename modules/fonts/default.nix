{ pkgs, ... }: {

  # fonts that are reachable by applications. ie: figma
  fonts.fonts = [
    # builtins.readFile(./custom_font.ttf) # custom font
    pkgs.google-fonts
    pkgs.nerdfonts
  ];

}
