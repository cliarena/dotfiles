{ config, lib, pkgs, ... }:
let
  module = "_gaming";
  description = "gaming config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.steam.enable = true;
    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
      wineWowPackages.waylandFull # needed to run any emulated game
      lutris # game launcher
      protonplus # Wine and Proton-based compatibility tools manager
      cartridges # GTK4 game launcher
      mangohud # Performance overlay
    ];

  };
}
