{ config, lib, ... }:
let
  module = "_conform";
  deskription = "light & powerful formatter";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.conform-nvim = {
      enable = true;

      formatters_by_ft = {
        nix = [ "nixfmt" ];
        zig = [ "zigfmt" ];

        "*" =
          [ "codespell" "squeeze_blanks" "trim_whitespace" "trim_newlines" ];
      };
      format_after_save.lsp_format = "fallback";
    };

  };
}
