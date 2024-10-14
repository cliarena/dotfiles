{ config, inputs, lib, ... }:
let
  module = "_catppuccin";
  description = "catppuccin theme";
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };

}
