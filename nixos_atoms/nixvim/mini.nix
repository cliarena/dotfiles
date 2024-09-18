{ config, lib, ... }:
let
  module = "_mini";
  deskription = "mini modules";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        bufremove = { };
        completion = { };
        comment = { };
        cursorword = { };
        clue = { };
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
        jump2d = { };
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
