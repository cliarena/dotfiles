{ config, lib, ... }:

let inherit (lib) mkEnableOption mkIf fileset;
in {

  # imports = nixos_modules_list;
  imports = fileset.toList ../nixos_modules;

  options.profiles.common.enable = mkEnableOption "conding profile";

  config = mkIf config.profiles.common.enable {

    _nix.enable = true;
    _users.enable = true;
    _catppuccin.enable = true;
    _nixvim.enable = true;

    _pkgs_base.enable = true;
  };
}
