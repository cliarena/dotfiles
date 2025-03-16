{ config, lib, inputs, pkgs, ... }:
let
  module = "_polaris";
  description = "polaris audio server";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    services.polaris = {
      enable = true;
      settings = {
        settings.reindex_every_n_seconds = 7 * 24 * 60
          * 60; # weekly, default is 1800
        settings.album_art_pattern =
          "(cover|front|folder).(jpeg|jpg|avif|webp)";
        mount_dirs = [
          {
            name = "Quran";
            source = "/srv/library/quran";
          }
          {
            name = "audio";
            source = "/srv/library/audio";
          }
        ];
        users = [{
          admin = true;
          name = "cliarena";
          password = "cliarena";
        }];
      };
    };

  };
}
