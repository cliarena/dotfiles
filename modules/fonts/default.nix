{ pkgs, ... }: {

  # fonts that are reachable by applications. ie: figma
  fonts.packages = with pkgs; [
    ./techy
    google-fonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

}
