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
      # enable = false;
      description = "stream desktop containers";
      environment = {
        WOLF_CFG_FILE = "/srv/wolf/cfg/config.toml";
        WOLF_PRIVATE_KEY_FILE = "/srv/wolf/cfg/key.pem";
        WOLF_PRIVATE_CERT_FILE = "/srv/wolf/cfg/cert.pem";
        HOST_APPS_STATE_FOLDER = "/srv/wolf/state";
      };
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
