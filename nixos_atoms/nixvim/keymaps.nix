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
        {
          key = "<leader>tv";
          action = "<cmd>lua Toggle_vertualEdit()<CR><cr>";
          options = { desc = "Virtual Edit"; };
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
          # key = "<leader>wn";
          key = "<C-Left>";
          action = "<cmd>SmartCursorMoveLeft<cr>";
          options.desc = "Move left";
        }
        {
          # key = "<leader>we";
          key = "<C-Down>";
          action = "<cmd>SmartCursorMoveDown<cr>";
          options.desc = "Move Down";
        }
        {
          # key = "<leader>wu";
          key = "<C-Up>";
          action = "<cmd>SmartCursorMoveUp<cr>";
          options.desc = "Move up";
        }
        {
          # key = "<leader>wi";
          key = "<C-Right>";
          action = "<cmd>SmartCursorMoveRight<cr>";
          options.desc = "Move right";
        }
        {
          # key = "<leader>wo";
          key = "<C-\\>";
          action = "<cmd>lua require('smart-splits').move_cursor_previous<cr>";
          options.desc = "Move prev";
        }
        {
          key = "<leader>wSn";
          action = "<cmd>SmartSwapLeft<cr>";
          options.desc = "Left";
        }
        {
          key = "<leader>wSe";
          action = "<cmd>SmartSwapDown<cr>";
          options.desc = "Down";
        }
        {
          key = "<leader>wSu";
          action = "<cmd>SmartSwapUp<cr>";
          options.desc = "Up";
        }
        {
          key = "<leader>wSi";
          action = "<cmd>SmartSwapRight<cr>";
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
          # key = "<leader>wrn";
          key = "<A-Left>";
          action = "<cmd>SmartResizeLeft<cr>";
          options.desc = "Left";
        }
        {
          # key = "<leader>wre";
          key = "<A-Down>";
          action = "<cmd>SmartResizeDown<cr>";
          options.desc = "Down";
        }
        {
          # key = "<leader>wru";
          key = "<A-Up>";
          action = "<cmd>SmartResizeUp<cr>";
          options.desc = "Up";
        }
        {
          # key = "<leader>wri";
          key = "<A-Right>";
          action = "<cmd>SmartResizeRight<cr>";
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
        ############   Venn ASCII   ############
        {
          key = "<S-Left>";
          action = "<C-v>h:VBox<cr>";
          mode = "n";
          options.desc = "Draw Left";
        }
        {
          key = "<S-Down>";
          action = "<C-v>j:VBox<cr>";
          mode = "n";
          options.desc = "Draw Down";
        }
        {
          key = "<S-Up>";
          action = "<C-v>k:VBox<cr>";
          mode = "n";
          options.desc = "Draw Up";
        }
        {
          key = "<S-Right>";
          action = "<C-v>l:VBox<cr>";
          mode = "n";
          options.desc = "Draw Right";
        }
        {
          key = "<S-Home>";
          action = ":VBox<cr>";
          mode = "v";
          options.desc = "Draw Box";
        }
      ];
    };

  };

}
