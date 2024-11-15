{ config, lib, inputs, ... }:
let
  module = "_wolf";
  description = "stream desktops containers";
  inherit (lib) mkEnableOption mkIf;
  wolf_bin = "${inputs.wolf.packages.x86_64-linux.default}/bin/wolf";

in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    environment.systemPackages = [ inputs.wolf.packages.x86_64-linux.default ];
    systemd.services.wolf = {
      enable = false;
      # path = [ inputs.wolf.packages.x86_64-linux.default ];
      description = "stream desktops containers";
      # environment = { VAULT_ADDR = "https://vault.cliarena.com:8200"; };
      script = wolf_bin;
      serviceConfig = {
        Restart = "on-failure";
        # avoid error start request repeated too quickly since RestartSec defaults to 100ms
        RestartSec = 3;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
