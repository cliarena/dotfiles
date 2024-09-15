{ config, lib, pkgs, ... }:
let
  module = "_nix";
  deskription = "nix config";
  inherit (lib) mkEnableOption mkIf;
in {

  # fonts that are reachable by applications. ie: figma
  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    nix = {
      # Constrain access to nix daemon
      settings.allowed-users = [ "@wheel" "hydra" "hydra-www" ];
      settings.trusted-users = [ "@wheel" "hydra" "hydra-www" ];
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
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
        warn-dirty = false
      '';

      # Garbage Collection
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

  };
}
