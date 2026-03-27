{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_oci_wolf";
  description = "Wolf streaming server";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.pulseaudio = {
      # Needed by wolf to get audio
      enable = true;
      systemWide = true;
    };

    virtualisation.oci-containers.containers.wolf = {
      privileged = true;
      image = "ghcr.io/games-on-whales/wolf:stable";

      ports = [
        "47984:47984/tcp"
        "47989:47989/tcp"
        "47999:47999/udp"
        "48010:48010/tcp"

        # Video port for each user
        "48100-48103:48100-48103/udp"

        # Audio port for each user
        "48200-48203:48200-48203/udp"
      ];

      environment = {
        # WOLF_LOG_LEVEL = "DEBUG";

        # WOLF_DOCKER_SOCKET = "/var/run/podman/podman.sock";
        # HOST_APPS_STAT_FOLDER = "/etc/wolf";
        # WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
        # WOLF_PRIVATE_KEY_FILE = "/etc/wolf/cfg/";
        # WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
        XDG_RUNTIME_DIR = "/tmp/sockets";
        # WOLF_PULSE_IMAGE = "";
        WOLF_PULSE_CONTAINER_TIMEOUT_MS = "10000";
        # XDG_RUNTIME_DIR = "/run/user/1000";
      };

      volumes = [
        # "/run/user/1000:/run/user/1000:rw"
        "/tmp/sockets:/tmp/sockets:rw"
        # "/run/pulse:/tmp/sockets/pulse:rw"
        "/srv/volumes/wolf/:/etc/wolf"

        "/srv/library/icons:/srv/library/icons" # icons for moonlight apps
        "/nix/store:/nix/store:ro" # to run nixos pkgs
        "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs

        "/var/run/podman/podman.sock:/var/run/docker.sock:rw"
        "/dev/:/dev/:rw"
        "/run/udev:/run/udev:rw"
      ];
      devices = [

        "/dev/dri:/dev/dri"
        "/dev/uinput:/dev/uinput"
        "/dev/uhid:/dev/uhid"

      ];
    };
    systemd.services.podman-wolf.preStart = "${pkgs.podman}/bin/podman rm -f WolfPulseAudio";
   
    # systemd.services.podman-wolf.serviceConfig = {
    #   # User = "root";
    #   Group = "pulse-access";
    #   Restart = "on-failure";
    #   TimeoutSec = 3;
    #   # avoid error start request repeated too quickly since RestartSec defaults to 100ms
    #   RestartSec = 3;
    # };
  };
}
