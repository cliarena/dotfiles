{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  module = "_hydra_image_importer";
  description = "imports images from hydra";
  inherit (lib) mkEnableOption mkIf;

  image_name = "main";
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    systemd.timers."hydra-image-importer" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "24h";
        Unit = "hydra-image-importer.service";
      };
    };

    systemd.services."hydra-image-importer" = {
      script = ''
        ${pkgs.wget}/bin/wget http://10.10.0.10:9999/job/nixos/main/x86_64-linux.${image_name}/latest/download/nixos-system-x86_64-linux.tar.xz && ${pkgs.xz}/bin/unxz nixos-system-x86_64-linux.tar.xz && ${pkgs.podman}/bin/podman import nixos-system-x86_64-linux.tar nixos
      '';
      postStop = "${pkgs.coreutils}/bin/rm -f nixos-system-x86_64-linux.tar nixos-system-x86_64-linux.tar.xz";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
