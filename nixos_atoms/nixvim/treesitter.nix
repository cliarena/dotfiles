{ config, lib, ... }:
let
  module = "_treesitter";
  description = "treesitter config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<Leader>ss";
            node_incremental = "<Leader>si";
            scope_incremental = "<Leader>sc";
            node_decremental = "<Leader>sd";
          };
        };
      };
    };

  };
}
