{
  config,
  inputs,
  lib,
  ...
}:
let
  module = "_audiobookshelf";
  description = "Audiobook & Podcast Server";
  inherit (lib) mkEnableOption mkIf;
in
{
  # imports = [ inputs.comin.nixosModules.comin ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
    };
  };
}
