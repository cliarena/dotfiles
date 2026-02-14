{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_easyread";
  description = "Bionic like reading";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.extraPlugins = [ pkgs.vimPlugins.easyread-nvim ];
  };
}
