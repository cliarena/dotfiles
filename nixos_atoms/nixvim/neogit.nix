{ config, lib, ... }:
let
  module = "_neogit";
  deskription = "magit for neovim";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.neogit = { enable = true; };
  };

}
