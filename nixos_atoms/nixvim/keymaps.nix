{ config, lib, ... }:
let
  module = "_keymaps";
  deskription = "keymaps";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim = {
      globals.mapleader = " ";

      keymaps = [
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
          key = "<leader>te";
          options = { desc = "Explorer"; };
        }
        {
          action = "<cmd>Neogit<cr>";
          key = "<leader>tg";
          options = { desc = "Git"; };
        }
        ############   LSP   ############
        {
          action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
          key = "<leader>ln";
          options = { desc = "Next Diagnostic"; };
        }
        {
          action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
          key = "<leader>lN";
          options = { desc = "Prev Diagnostic"; };
        }
        {
          key = "<leader>lx";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options.desc = "Diagnostics (Trouble)";
        }
        {
          key = "<leader>lX";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options.desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>ls";
          action = "<cmd>Trouble symbols toggle focus=false<cr>";
          options.desc = "Symbols (Trouble)";
        }
        {
          key = "<leader>ll";
          action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
          options.desc = "LSP Definitions / references / ... (Trouble)";
        }
        {
          key = "<leader>lL";
          action = "<cmd>Trouble loclist toggle<cr>";
          options.desc = "Location List (Trouble)";
        }
        {
          key = "<leader>lq";
          action = "<cmd>Trouble qflist toggle<cr>";
          options.desc = "Quickfix List (Trouble)";
        }
        {
          key = "<leader>li";
          action = "<cmd>LspInfo<cr>";
          options.desc = "Info";
        }
        ############   Split   ############
        {
          key = "<leader>ws";
          action = "<cmd>vsplit<cr>";
          options.desc = "Split Right";
        }
        {
          key = "<leader>wS";
          action = "<cmd>wincmd=<cr>";
          options.desc = "Split Evenly";
        }
        {
          key = "<leader>wh";
          action = "<cmd>split<cr>";
          options.desc = "Split Bottom";
        }
        {
          key = "<leader>ww";
          action = "<cmd>w!<cr>";
          options.desc = "Save";
        }
        {
          key = "<leader>wc";
          action = "<cmd>lua MiniBufremove.delete()<cr>";
          options.desc = "Close Buffer";
        }
        {
          key = "<leader>wq";
          action = "<cmd>q!<cr>";
          options.desc = "Quit";
        }
      ];
    };

  };

}
