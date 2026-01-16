{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_treesitter";
  description = "treesitter config";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim = {
      plugins.hmts.enable = true; # highlight home-manager strings
      plugins.treesitter = {
        enable = true;
        folding.enable = false;
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

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          zig
          html
          css
          sql

          jq
          json
          json5
          gnuplot

          diff
          git-config
          git-rebase
          gitattributes
          gitcommit
          gitignore

          csv
          tsv
          toml
          yaml
          editorconfig

          lua
          luadoc
          regex
          # robots
          mermaid
          hcl
          dockerfile
          # terraform

          nu
          bash
          nix
          pkgs.tree-sitter-grammars.tree-sitter-norg
          pkgs.tree-sitter-grammars.tree-sitter-norg-meta
        ];
      };

      # extraFiles = {
      #   #  ((((comment) @injection.language) .
      #   #  (string (string_content) @injection.content))
      #   #  (#set! injection.combined))
      #   "queries/zig/injections.scm" = {
      #     enable = true;
      #     text =
      #       # scheme
      #       ''
      #         ;; extends
      #         ((string) @injection.content
      #           (#set! injection.include-children)
      #           (#set! injection.language "lua"))
      #
      #         ((comment) @injection.language
      #           . ; this is to make sure only adjacent comments are accounted for the injections
      #           [
      #             (string
      #               (string_content) @injection.content)
      #               ((multiline_string) @injection.content)
      #           ]
      #           (#set! injection.include-children)
      #           (#set! injection.language "html"))
      #
      #           ; (#gsub! @injection.language "//%s*([%w%p]+)%s*" "%1")
      #           ; (#set! injection.combined))
      #
      #         (variable_declaration
      #           ((identifier) @_path)
      #           [
      #             ((string) @injection.content
      #               (#set! injection.language "lua"))
      #             ; ((multiline_string) @injection.content
      #             ;       (#set! injection.language "lua"))
      #           ]
      #           (#match? @_path "(^(configLua(Pre|Post)?|__raw))$"))
      #       '';
      #   };
      # };
    };
  };
}
