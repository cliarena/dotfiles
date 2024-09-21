{ config, lib, ... }:
let
  module = "_lint";
  deskription = "light & powerful linter";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.lint = {
      enable = true;

      lintersByFt = { nix = [ "nix" "deadnix" ]; };
    };

  };
}
