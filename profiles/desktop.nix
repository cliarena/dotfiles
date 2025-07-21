{ config, lib, ... }:
let
  module = "desktop";
  description = "desktop profile";
  inherit (lib) mkEnableOption mkIf fileset;
in {

  imports = fileset.toList ../nixos_modules;

  options.profiles.${module}.enable = mkEnableOption description;

  config = mkIf config.profiles.${module}.enable {

    fonts.enable = true;
    _pipewire.enable = true;
    _pkgs_desktop.enable = true;
    _chromium.enable = true;

    _home.enable = true;
    _home_wezterm.enable = true;
    _home_qutebrowser.enable = true;
    _sops_home.enable = true;
    _ssh_home.enable = true;

    _shell.enable = true;
    _git.enable = true;
    _bottom.enable = true;
    _direnv.enable = true;

  #  _eww.enable = true;
    _river.enable = true;
  };
}
