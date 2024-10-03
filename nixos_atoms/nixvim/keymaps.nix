{ config, lib, ... }:
let
  module = "_keymaps";
  deskription = "keymaps";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.keymaps = [
      # Navigation
      {
        action = "<Down>";
        key = "e";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Up>";
        key = "l";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Right>";
        key = "a";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Left>";
        key = "n";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<cmd>lua MiniFiles.open()<cr>";
        key = "gte";
        options = { desc = "Explorer"; };
      }
      {
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        key = "gln";
        options = { desc = "Next Diagnostic"; };
      }
      {
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        key = "glN";
        options = { desc = "Prev Diagnostic"; };
      }
    ];

  };

}
