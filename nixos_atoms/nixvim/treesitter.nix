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
              (string (string_content) @injection.content
              (#set! injection.language "html"))
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
            '';
        };
      };
    };
  };
}
