{
  config,
  lib,
  ...
}: let
  module = "_treesitter";
  description = "treesitter config";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim = {
      plugins.hmts.enable = true; # highlight home-manager strings
      plugins.treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<Leader>ss";
              node_incremental = "<Leader>si";
              scope_incremental = "<Leader>sc";
              node_decremental = "<Leader>sd";
            };
          };
        };
      };

      extraFiles = {
        #  ((((comment) @injection.language) .
        #  (string (string_content) @injection.content))
        #  (#set! injection.combined))
        "queries/zig/injections.scm" = {
          enable = true;
          text =
            # scheme
            ''
              ;; extends
              ((string) @injection.content
                (#set! injection.include-children)
                (#set! injection.language "lua"))

              ((comment) @injection.language
                . ; this is to make sure only adjacent comments are accounted for the injections
                [
                  (string
                    (string_content) @injection.content)
                    ((multiline_string) @injection.content)
                ]
                (#set! injection.include-children)
                (#set! injection.language "html"))

                ; (#gsub! @injection.language "//%s*([%w%p]+)%s*" "%1")
                ; (#set! injection.combined))

              (variable_declaration
                ((identifier) @_path)
                [
                  ((string) @injection.content
                    (#set! injection.language "lua"))
                  ; ((multiline_string) @injection.content
                  ;       (#set! injection.language "lua"))
                ]
                (#match? @_path "(^(configLua(Pre|Post)?|__raw))$"))
            '';
        };
      };
    };
  };
}
