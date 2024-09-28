{ config, inputs, lib, pkgs, ... }:
let
  module = "_nixvim";
  deskription = "neovim the nix way";
  inherit (lib) mkEnableOption mkIf fileset;

in {
  imports = [ inputs.nixvim.nixosModules.nixvim ]
    ++ fileset.toList ../nixos_atoms/nixvim;

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.enable = true;

    _options.enable = true;
    _keymaps.enable = true;
    _better_escape.enable = true;
    _mini.enable = true;

  };
}
