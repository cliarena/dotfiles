{ config, lib, ... }:
let
  module = "_mini";
  description = "mini modules";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        ai = { };
        bufremove = { };
        bracketed = { };
        completion = { };
        comment = { };
        cursorword = { };
        jump2d = {
          allowed_lines.blank = false;
          view = {
            dim = true;
            n_steps_ahead = 4;
          };
        };
        files = { };
        fuzzy = { };
        icons = { };
        pick = { };
        trailspace = { };
        visits = { };

        statusline = { content.active = null; };
        sessions = { };
        surround = { };
        move = {
          mappings = {
            ## Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "<M-Left>";
            right = "<M-Right>";
            down = "<M-Down>";
            up = "<M-Up>";

            ## Move current line in Normal mode
            line_left = "<M-Left>";
            line_right = "<M-Right>";
            line_down = "<M-Down>";
            line_up = "<M-Up>";
          };
        };

        hipatterns = {
          highlighters = {
            fixme = {
              pattern = "%f[%w]()FIXME()%f[%W]";
              group = "MiniHipatternsFixme";
            };
            hack = {
              pattern = "%f[%w]()HACK()%f[%W]";
              group = "MiniHipatternsHack";
            };
            todo = {
              pattern = "%f[%w]()TODO()%f[%W]";
              group = "MiniHipatternsTodo";
            };
            note = {
              pattern = "%f[%w]()NOTE()%f[%W]";
              group = "MiniHipatternsNote";
            };

            hex_color = {
              __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
            };
          };
        };
        clue = {
          # TODO:
          # - Yank all
          triggers = [
            # Leader triggers
            {
              mode = "n";
              keys = "<Leader>";
            }
            {
              mode = "x";
              keys = "<Leader>";
            }

            # Built-in completion
            {
              mode = "i";
              keys = "<C-x>";
            }
            # Next Prev
            {
              mode = "n";
              keys = "[";
            }
            {
              mode = "x";
              keys = "[";
            }
            {
              mode = "n";
              keys = "]";
            }
            {
              mode = "x";
              keys = "]";
            }
            # `g` key
            {
              mode = "n";
              keys = "g";
            }
            {
              mode = "x";
              keys = "g";
            }

            # Marks
            {
              mode = "n";
              keys = "'";
            }
            {
              mode = "n";
              keys = "`";
            }
            {
              mode = "x";
              keys = "'";
            }
            {
              mode = "x";
              keys = "`";
            }

            # Registers
            {
              mode = "n";
              keys = ''"'';
            }
            {
              mode = "x";
              keys = ''"'';
            }
            {
              mode = "i";
              keys = "<C-r>";
            }
            {
              mode = "c";
              keys = "<C-r>";
            }

            # Window commands
            {
              mode = "n";
              keys = "<C-w>";
            }

            # `z` key
            {
              mode = "n";
              keys = "z";
            }
            {
              mode = "x";
              keys = "z";
            }
          ];

          clues = [
            {
              mode = "n";
              keys = "<leader>t";
              desc = "Toggle";
            }
            {
              mode = "n";
              keys = "<leader>tt";
              desc = "Test";
            }
            {
              mode = "n";
              keys = "<leader>l";
              desc = "LSP";
            }
            {
              mode = "n";
              keys = "<leader>w";
              desc = "Window";
            }
            { __raw = "require('mini.clue').gen_clues.builtin_completion()"; }
            { __raw = "require('mini.clue').gen_clues.g()"; }
            { __raw = "require('mini.clue').gen_clues.marks()"; }
            { __raw = "require('mini.clue').gen_clues.registers()"; }
            { __raw = "require('mini.clue').gen_clues.windows()"; }
            { __raw = "require('mini.clue').gen_clues.z()"; }
          ];
        };
        diff = {
          view = {
            style = "sign";
            signs = {
              add = "▎";
              change = "▎";
              delete = "▎";
            };
          };
        };
        starter = {
          content_hooks = {
            "__unkeyed-1.adding_bullet" = {
              __raw = "require('mini.starter').gen_hook.adding_bullet()";
            };
            "__unkeyed-2.indexing" = {
              __raw =
                "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
            };
            "__unkeyed-3.padding" = {
              __raw =
                "require('mini.starter').gen_hook.aligning('center', 'center')";
            };
          };
          evaluate_single = true;
          header = ''
            ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
            ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
            ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          '';
          items = {
            "__unkeyed-1.buildtin_actions" = {
              __raw = "require('mini.starter').sections.builtin_actions()";
            };
            "__unkeyed-2.recent_files_current_directory" = {
              __raw =
                "require('mini.starter').sections.recent_files(10, false)";
            };
            "__unkeyed-3.recent_files" = {
              __raw = "require('mini.starter').sections.recent_files(10, true)";
            };
            "__unkeyed-4.sessions" = {
              __raw = "require('mini.starter').sections.sessions(5, true)";
            };
          };
        };
      };
    };
  };

}
