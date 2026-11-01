{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_gaming";
  description = "gaming config";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "steam" ];

    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
      steam-run
      wineWow64Packages.waylandFull # needed to run any emulated game
      lutris # game launcher
      protonplus # Wine and Proton-based compatibility tools manager
      cartridges # GTK4 game launcher
      mangohud # Performance overlay
      linuxConsoleTools # testing joysticks & controllers
    ];

# Lutris Esync compatibility
systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [{
    domain = "yourusername";
    type = "hard";
    item = "nofile";
    value = "524288";
  }];
  };
}
