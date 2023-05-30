{ pkgs, ... }: {

  # fonts that are reachable by applications. ie: figma
  fonts.fonts = with pkgs; [
    ./techy
    google-fonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

}
