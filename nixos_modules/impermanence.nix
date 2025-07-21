{
  config,
  lib,
  inputs,
  ...
}: let
  module = "_impermanence";
  description = "persistence for ephemeral systems";
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.persistence."/srv" = {
      enable = true; # NB: Defaults to true, not needed
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        {
          directory = "/var/lib/hydra";
          user = "hydra";
          group = "hydra";
        }
        {
          directory = "/var/lib/postgresql";
          user = "postgres";
          group = "postgres";
        }
      ];
    };
  };
}
