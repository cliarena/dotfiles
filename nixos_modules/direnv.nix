{ config, lib, host, ... }:
let
  module = "_direnv";
  description = "auto load environments";
  inherit (lib) mkEnableOption mkIf;
  inherit (config.home) homeDirectory;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
          config = {
            whitelist.prefix = [
              "${homeDirectory}/dotfiles"
              "${homeDirectory}/project_main"
              "${homeDirectory}/project_seconday"
            ];
          };
        };
      };
    };
  };
}
