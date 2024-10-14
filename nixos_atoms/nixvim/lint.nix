{ config, lib, ... }:
let
  module = "_lint";
  description = "light & powerful linter";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.lint = {
      enable = true;

      lintersByFt = { nix = [ "nix" "deadnix" ]; };
    };

  };
}
