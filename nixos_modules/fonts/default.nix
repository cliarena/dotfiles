{ config, lib, pkgs, ... }:
let inherit (lib) mkEnableOption mkIf;
in {

  # fonts that are reachable by applications. ie: figma
  options.fonts.enable = mkEnableOption "Beautiful fonts";

  config = mkIf config.fonts.enable {

    fonts.packages = with pkgs;
      [
        # ./techy
        # ./kust
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];
  };

}