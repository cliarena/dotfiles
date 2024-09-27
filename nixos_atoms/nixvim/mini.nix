{ config, lib, ... }:
let
  module = "_mini";
  deskription = "mini modules";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        bufremove = { };
        bracketed = { };
        completion = { };
        comment = { };
        cursorword = { };
        jump2d = { };
        files = { };
        fuzzy = { };
        pick = { };
        trailspace = { };
        visits = { };

        statusline = { content.active = null; };
        surround = { };

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

            hex_color =
              "require('mini.hipatterns').hipatterns.gen_highlighter.hex_color()";
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

          clues = {
            "__unkeyed-1.builtin_completion" = {
              __raw = "require('mini.clue').gen_clues.builtin_completion()";
            };
            "__unkeyed-2.g" = { __raw = "require('mini.clue').gen_clues.g()"; };
            "__unkeyed-3.marks" = {
              __raw = "require('mini.clue').gen_clues.marks()";
            };
            "__unkeyed-4.registers" = {
              __raw = "require('mini.clue').gen_clues.registers()";
            };
            "__unkeyed-5.windows" = {
              __raw = "require('mini.clue').gen_clues.windows()";
            };
            "__unkeyed-6.z" = { __raw = "require('mini.clue').gen_clues.z()"; };
          };
        };
        diff = {
          view = {
            signs = {
              add = "▎";
              change = "▎";
              delete = "▎";
            };
          };
          mappings = {
            apply = "gn";
            reset = "gN";
            textobject = "gn";

            goto_first = "[N";
            goto_prev = "[n";
            goto_next = "]n";
            goto_last = "]N";
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
