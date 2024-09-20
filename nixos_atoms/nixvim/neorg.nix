{ config, lib, ... }:
let
  module = "_neorg";
  deskription = "org mode for neovim";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.neorg = { enable = true; };
  };

}
