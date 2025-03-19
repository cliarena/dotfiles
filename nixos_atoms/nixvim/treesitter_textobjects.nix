{ config, lib, ... }:
let
  module = "_treesitter_textobjects";
  description = "treesitter textobjects config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.treesitter-textobjects = {
      enable = true;
      lspInterop = {
        enable = true;
        peekDefinitionCode = {
          "<leader>df" = {
            desc = "fn definition";
            query = "@function.outer";
          };
        };
      };
      move = {
        enable = true;
        setJumps = true; # whether to set jumps in the jumplist
        gotoNextStart = {
          "]c" = {
            query = "@conditional.outer";
            desc = "Next conditional start";
          };
          "]f" = {
            query = "@function.outer";
            desc = "Next function start";
          };
          "]p" = {
            query = "@parameter.inner";
            desc = "Next parameter start";
          };
          "]]" = {
            query = "@class.outer";
            desc = "Next class start";
          };
          # You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
          "]l" = {
            query = "@loop.*";
            desc = "Next loop start";
          };
          "]s" = {
            query = "@scope";
            queryGroup = "locals";
            desc = "Next scope";
          };
          "]z" = {
            query = "@fold";
            queryGroup = "folds";
            desc = "Next fold";
          };
        };
        gotoNextEnd = {
          "]C" = {
            query = "@conditional.outer";
            desc = "Next conditional end";
          };
          "]F" = {
            query = "@function.outer";
            desc = "Next function end";
          };
          "][" = {
            query = "@class.outer";
            desc = "Next class end";
          };
        };
        gotoPreviousStart = {
          "[c" = {
            query = "@conditional.outer";
            desc = "Prev conditional start";
          };
          "[f" = {
            query = "@function.outer";
            desc = "Prev function start";
          };
          "[p" = {
            query = "@parameter.inner";
            desc = "Prev parameter start";
          };
          "[[" = {
            query = "@class.outer";
            desc = "Prev class start";
          };
        };
        gotoPreviousEnd = {
          "[C" = {
            query = "@conditional.outer";
            desc = "Prev conditional end";
          };
          "[F" = {
            query = "@function.outer";
            desc = "Prev function end";
          };
          "[]" = {
            query = "@class.outer";
            desc = "Prev class end";
          };
        };
      };
      select = {
        enable = true;
        lookahead = true;

        keymaps = {
          "af" = {
            query = "@function.outer";
            desc = "Select outer function";
          };
          "if" = {
            query = "@function.inner";
            desc = "Select inner function";
          };
          "ac" = {
            query = "@class.outer";
            desc = "Select outer class";
          };
          "ic" = {
            query = "@class.inner";
            desc = "Select inner class";
          };
          "as" = {
            query = "@scope";
            queryGroup = "locals";
            desc = "Select language scope";
          };
        };
        selectionModes = {
          "@parameter.outer" = "v"; # charwise
          "@function.outer" = "v"; # linewise
          "@class.outer" = "<c-v>"; # blockwise
        };
        includeSurroundingWhitespace = true;
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>pp" = {
            query = "@parameter.inner";
            desc = "Swap parameter with the next";
          };
        };
        swapPrevious = {
          "<leader>pP" = {
            query = "@parameter.inner";
            desc = "Swap parameter with the prev";
          };
        };
      };
    };

  };
}
