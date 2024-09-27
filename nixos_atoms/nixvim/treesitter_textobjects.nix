{ config, lib, ... }:
let
  module = "_treesitter_textobjects";
  deskription = "treesitter textobjects config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

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
        move = {
          enable = true;
          set_jumps = true; # whether to set jumps in the jumplist
          goto_next_start = {
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
              query_group = "locals";
              desc = "Next scope";
            };
            "]z" = {
              query = "@fold";
              query_group = "folds";
              desc = "Next fold";
            };
          };
          goto_next_end = {
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
          goto_previous_start = {
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
          goto_previous_end = {
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
              query_group = "locals";
              desc = "Select language scope";
            };
          };
          selection_modes = {
            "@parameter.outer" = "v"; # charwise
            "@function.outer" = "v"; # linewise
            "@class.outer" = "<c-v>"; # blockwise
          };
          include_surrounding_whitespace = true;
        };
        swap = {
          enable = true;
          swap_next = {
            "<leader>Sp" = {
              query = "@parameter.inner";
              desc = "Swap parameter with the next";
            };
          };
          swap_previous = {
            "<leader>SP" = {
              query = "@parameter.inner";
              desc = "Swap parameter with the prev";
            };
          };
        };
      };
    };

  };
}
