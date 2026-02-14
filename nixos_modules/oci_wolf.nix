{
  config,
  lib,
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
        "0.0.0.0::47984/tcp"
        "0.0.0.0::47989/tcp"
        "0.0.0.0::47999/udp"
        "0.0.0.0::48010/tcp"

        # Video port for each user
        "0.0.0.0::48100/udp"
        "0.0.0.0::48101/udp"
        "0.0.0.0::48102/udp"
        "0.0.0.0::48103/udp"

        # Audio port for each user
        "0.0.0.0::48200/udp"
        "0.0.0.0::48201/udp"
        "0.0.0.0::48202/udp"
        "0.0.0.0::48203/udp"
      ];

      environment = {
        # WOLF_DOCKER_SOCKET = "/var/run/podman/podman.sock";
        # HOST_APPS_STAT_FOLDER = "/etc/wolf";
        # WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
        # WOLF_PRIVATE_KEY_FILE = "/etc/wolf/cfg/";
        # WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
        WOLF_PULSE_CONTAINER_TIMEOUT_MS = "5000";
      };

      volumes = [
        "/tmp/sockets:/tmp/sockets:rw"
        "/srv/volumes/wolf/:/etc/wolf"

        "/srv/library/icons:/srv/library/icons" # icons for moonlight apps
        "/nix/store:/nix/store:ro" # to run nixos pkgs
        "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs

        "/run/user/1000/:/tmp/sockets:rw"
        "/var/run/docker.sock:/var/run/docker.sock:rw"
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
  };
}
