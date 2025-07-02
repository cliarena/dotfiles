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
#      systemWide = true;
    };
  };
}
