{
  config,
  lib,
  ...
}: let
  module = "_neogit";
  description = "magit for neovim";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.neogit = {enable = true;};
  };
}
