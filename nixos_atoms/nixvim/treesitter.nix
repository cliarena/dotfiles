{ config, lib, ... }:
let
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
        nixvimInjections = false;
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
          text = # scheme
            ''
              ;; extends
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
                  (string
                    ((string_content) @injection.content
                      (#set! injection.language "lua")))
                  ((multiline_string) @injection.content
                        (#set! injection.language "lua"))
                ]
                (#match? @_path "(^(config_lua(Pre|Post)?|__raw))$"))
            '';
        };
        "queries/nix/injections.scm" = {
          enable = true;
          text = # scheme
            ''
              ;; extends
              (binding
                attrpath: (attrpath
                  (identifier) @_path)
                expression: [
                  (string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "lua")))
                  (indented_string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "lua")))
                ]
                (#match? @_path "(^(extraConfigLuax(Pre|Post)?|__raw))$"))

              (binding
                attrpath: (attrpath
                  (identifier) @_path)
                expression: [
                  (string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "html")))
                  (indented_string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "html")))
                ]
                (#match? @_path "(^(extraConfigHtml(Pre|Post)?|__raw))$"))

              (binding
                attrpath: (attrpath
                  (identifier) @_path)
                expression: [
                  (string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "css")))
                  (indented_string_expression
                    ((string_fragment) @injection.content
                      (#set! injection.language "css")))
                ]
                (#match? @_path "(^(extraConfigCss(Pre|Post)?|__raw))$"))
            '';
        };
      };
    };
  };
}
