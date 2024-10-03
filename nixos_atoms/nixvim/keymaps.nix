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
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>cl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }
    ];

  };

}
