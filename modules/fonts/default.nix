{ pkgs, ... }: {

  # fonts that are reachable by applications. ie: figma
  fonts.fonts = [ ./techy pkgs.google-fonts pkgs.nerdfonts ];

}
