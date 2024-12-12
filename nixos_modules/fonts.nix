{ config, lib, pkgs, ... }:
let inherit (lib) mkEnableOption mkIf;
in {

  # fonts that are reachable by applications. ie: figma
  options.fonts.enable = mkEnableOption "Beautiful fonts";

  config = mkIf config.fonts.enable {

    fonts.packages = with pkgs; [
      ../nixos_atoms/fonts
      # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

    ];
  };

}
