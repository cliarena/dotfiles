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

  config = mkIf config.${module}.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "wezterm.nvim" ];
    nixpkgs.config.allowUnfree = true;

    programs.nixvim.plugins.wezterm = {
      enable = true;
    };
  };
}
