{
  config,
  lib,
  ...
}: let
  module = "_hydra";
  description = "CI for nix";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.hydra = {
      enable = true;
      hydraURL = "http://hydra.cliarena.com";
      port = 9999;
      notificationSender = "hydra@localhost";
      buildMachinesFiles = [];
      useSubstitutes = true;
    };

    services.nix-serve.enable = true;
  };
}
