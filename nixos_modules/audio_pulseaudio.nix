{
  config,
  lib,
  ...
}: let
  module = "_audio_pulseaudio";
  description = "audio server";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    security.rtkit.enable = true;

    services.pipewire.enable = false;
    services.pulseaudio.enable = true;
    services.pulseaudio.support32Bit = true;

  };
}
