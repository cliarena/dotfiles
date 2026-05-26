{
  config,
  lib,
  ...
}:
let
  module = "_wezterm";
  description = "Wezterm integration";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "wezterm.nvim"
    ];

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.wezterm = {
      enable = true;
    };
  };
}
