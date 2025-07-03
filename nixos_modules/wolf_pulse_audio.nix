{ config, lib, ... }:
let
  module = "_wolf_pulse_audio";
  description = "audio & video server";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    services.pulseaudio = { # Needed by wolf to get audio
      enable = true;
      systemWide = true;
    };
   # virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.wolf = {
      privileged = true;
      image = "ghcr.io/games-on-whales/wolf:stable";

      ports = [
        "47984/tcp"
        "47989/tcp"
        "47999/udp"
        "48010/tcp"
        "48100/udp"
        "48200/udp"
      ];
      
      environment = {
       # HOST_APPS_STAT_FOLDER = "/etc/wolf";
       ## WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
       # WOLF_PRIVATE_KEY_FILE = "/etc/wolf/cfg/";
       # WOLF_CFG_FILE = "/etc/wolf/cfg/config.toml";
        WOLF_PULSE_CONTAINER_TIMEOUT_MS = "5000";
      };

      volumes = [
        "/srv/volumes/wolf/:/etc/wolf" 
        "/tmp/sockets:/tmp/sockets:rw"
       # "/run/user/1000/:/tmp/sockets:rw"
       # "/var/run/docker.sock:/var/run/docker.sock:rw"
        "/var/run/podman/podman.sock:/var/run/docker.sock:rw"
        "/dev/:/dev/:rw"
        "/run/udev:/run/udev:rw"
     ];
    };
  };
}
