{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_nix";
  description = "nix config";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    system.stateVersion = "22.11";
    nix = {
      daemonCPUSchedPolicy = "idle"; # Deprioritizes nix builds for more predictable latencies
      channel.enable = false; # not needed using flakes
      # Constrain access to nix daemon
      settings.allowed-users = [
        "@wheel"
        "hydra"
        "hydra-www"
      ];
      settings.trusted-users = [
        "@wheel"
        "hydra"
        "hydra-www"
      ];
      settings.allowed-uris = [
        "github:"
        "https://github.com/"
        "git+https://github.com/"
        "git+ssh://github.com/"

        "gitlab:"
        "https://gitlab.com/"
        "git+https://gitlab.com/"
        "git+ssh://gitlab.com/"
      ];

      # Enable Flakes
      package = pkgs.nixVersions.latest;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
        warn-dirty = false
      '';

      # Garbage Collection
      # settings.auto-optimise-store = true; # slows ev build by alot
      optimise.automatic = true;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
