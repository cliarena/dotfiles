{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  module = "_hydra_image_importer";
  description = "imports images from hydra";
  inherit (lib) mkEnableOption mkIf;
  wolf_bin = "${inputs.wolf.packages.x86_64-linux.default}/bin/wolf";

in
{

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    environment.systemPackages = [ inputs.wolf.packages.x86_64-linux.default ];

systemd.timers."hydra-image-importer" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "24h";
      Unit = "hydra-image-importer.service";
    };
};

systemd.services."hydra-image-importer" = {
  script = ''
    set -eu
     ${pkgs.wget}/bin/wget http://10.10.0.10:9999/job/nixos/main/x86_64-linux.dev/latest/download/nixos-system-x86_64-linux.tar.xz && ${pkgs.xz}/bin/unxz nixos-system-x86_64-linux.tar.xz && ${pkgs.podman}/bin/podman import nixos-system-x86_64-linux.tar nixos; ${pkgs.coreutils}/bin/rm -f nixos-system-x86_64-linux.tar nixos-system-x86_64-linux.tar.xz
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "root";
  };
};

  };
}
