{ config, lib, ... }:
let
  module = "_keymaps";
  description = "keymaps";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim = {
      globals.mapleader = " ";

      keymaps = [
        ############   Toggles   ############
        {
          key = "<leader>te";
          action = "<cmd>lua MiniFiles.open()<cr>";
          options = { desc = "Explorer"; };
        }
        {
          key = "<leader>tg";
          action = "<cmd>Neogit<cr>";
          options = { desc = "Git"; };
        }
        {
          key = "<leader>ts";
          action =
            "<cmd>60 vs |:set signcolumn=no nonumber norelativenumber |:te nu<cr>";
          options = { desc = "Shell"; };
        }
        {
          key = "<leader>tp";
          action =
            "<cmd>60 vs |:set signcolumn=no nonumber norelativenumber |:te nu -e 'devenv up'<cr>";
          options = { desc = "Processes"; };
        }

        {
          key = "<leader>ta";
          action = "<cmd>ASToggle<cr>";
          options = { desc = "Auto Save"; };
        }
        ############   LSP   ############
        {
          key = "<leader>lf";
          action = "<cmd>lua require('conform').format()<cr>";
          options.desc = "Format";
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
        ############   Windows   ############
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
        {
          key = "<leader>wn";
          action = "<cmd>lua require('smart-splits').move_cursor_left<cr>";
          options.desc = "Move left";
        }
        {
          key = "<leader>we";
          action = "<cmd>lua require('smart-splits').move_cursor_down<cr>";
          options.desc = "Move Down";
        }
        {
          key = "<leader>wu";
          action = "<cmd>lua require('smart-splits').move_cursor_up<cr>";
          options.desc = "Move up";
        }
        {
          key = "<leader>wi";
          action = "<cmd>lua require('smart-splits').move_cursor_right<cr>";
          options.desc = "Move right";
        }
        {
          key = "<leader>wo";
          action = "<cmd>lua require('smart-splits').move_cursor_previous<cr>";
          options.desc = "Move prev";
        }
        {
          key = "<leader>wSn";
          action = "<cmd>lua require('smart-splits').swap_buf_left<cr>";
          options.desc = "Left";
        }
        {
          key = "<leader>wSe";
          action = "<cmd>lua require('smart-splits').swap_buf_down<cr>";
          options.desc = "Down";
        }
        {
          key = "<leader>wSu";
          action = "<cmd>lua require('smart-splits').swap_buf_up<cr>";
          options.desc = "Up";
        }
        {
          key = "<leader>wSi";
          action = "<cmd>lua require('smart-splits').swap_buf_right<cr>";
          options.desc = "Right";
        }
        {
          key = "<leader>wss";
          action = "<cmd>vsplit<cr>";
          options.desc = "Split Right";
        }
        {
          key = "<leader>wsS";
          action = "<cmd>wincmd=<cr>";
          options.desc = "Split Evenly";
        }
        {
          key = "<leader>wsh";
          action = "<cmd>split<cr>";
          options.desc = "Split Bottom";
        }
        {
          key = "<leader>wrn";
          action = "<cmd>lua require('smart-splits').resize_left<cr>";
          options.desc = "Left";
        }
        {
          key = "<leader>wre";
          action = "<cmd>lua require('smart-splits').resize_down<cr>";
          options.desc = "Down";
        }
        {
          key = "<leader>wru";
          action = "<cmd>lua require('smart-splits').resize_up<cr>";
          options.desc = "Up";
        }
        {
          key = "<leader>wri";
          action = "<cmd>lua require('smart-splits').resize_right<cr>";
          options.desc = "Right";
        }

        ############   Neotest   ############
        {
          key = "[t";
          action = "<cmd>Neotest jump prev<cr>";
          options.desc = "Prev Test";
        }
        {
          key = "]t";
          action = "<cmd>Neotest jump next<cr>";
          options.desc = "Next Test";
        }
        {
          key = "[T";
          action =
            "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>";
          options.desc = "Prev Test Failed";
        }
        {
          key = "]T";
          action =
            "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>";
          options.desc = "Next Test Failed";
        }
        {
          key = "<leader>tto";
          action =
            "<cmd>lua require('neotest').output.open({ enter = true })<cr>";
          options.desc = "Output";
        }
        {
          key = "<leader>ttw";
          action =
            "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>";
          options.desc = "Watch Current File";
        }
        {
          key = "<leader>tts";
          action = "<cmd>lua require('neotest').summary.toggle()<cr>";
          options.desc = "Summary";
        }
        {
          key = "<leader>ttd";
          action =
            "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>";
          options.desc = "Dap Debug";
        }
      ];
    };

  };

}
