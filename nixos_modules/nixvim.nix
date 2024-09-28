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
    _yanky.enable = true;
    _marks.enable = true;
    _spider.enable = true;

    _auto_cmds.enable = true;
    _auto_save.enable = true;
    _lastplace.enable = true;

    _mini.enable = true;
    _lsp.enable = true;
    _lint.enable = true;
    _conform.enable = true;
    _treesitter.enable = true;
    _treesitter_textobjects.enable = true;

    _trouble.enable = true;
    _neotest.enable = true;
    _neogit.enable = true;
    _neorg.enable = true;
    _twilight.enable = true;

    _inc_rename.enable = true;
    _hardtime.enable = true;
  };
}
