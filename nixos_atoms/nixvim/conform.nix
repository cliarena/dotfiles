{
  config,
  lib,
  ...
}: let
  module = "_conform";
  description = "light & powerful async formatter";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
          nix = ["nixfmt"];
          zig = ["zigfmt"];

          "*" = ["codespell" "squeeze_blanks" "trim_whitespace" "trim_newlines"];
        };
        format_after_save.lsp_format = "fallback";
      };
    };
  };
}
