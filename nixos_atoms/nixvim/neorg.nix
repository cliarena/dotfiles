{
  config,
  lib,
  ...
}: let
  module = "_neorg";
  description = "org mode for neovim";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.neorg = {
      enable = true;
      settings = {
        load = {
          "core.concealer" = {config = {icon_preset = "diamond";};};
          "core.defaults" = {__empty = null;};
          # "core.dirman" = {
          #   config = {
          #     workspaces = {
          #       home = "~/notes/home";
          #       work = "~/notes/work";
          #     };
          #   };
          # };
        };
      };
    };
  };
}
