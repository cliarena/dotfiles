{ config, lib, inputs, ... }:
let
  module = "_wolf";
  description = "stream desktops containers";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    systemd.services.wolf = {
      path = [ inputs.wolf.packages.x86_64-linux.default ];
      description = "stream desktops containers";
      # environment = { VAULT_ADDR = "https://vault.cliarena.com:8200"; };
      script = "ls && sudo wolf";
      serviceConfig = {
        Restart = "on-failure";
        # avoid error start request repeated too quickly since RestartSec defaults to 100ms
        RestartSec = 3;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
