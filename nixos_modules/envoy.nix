{ config, lib, pkgs, system, ... }:

let
  module = "_envoy";
  deskription = "cloud-native edge and service proxy";
  inherit (lib) mkEnableOption mkIf;

  envoy_nixpkgs = import (builtins.fetchGit {

    # NOTE: consul supports envoy version which is 0.7 to 0.10 higher
    # EXAMPLE: consul 1.19.x supports envoy 1.29.x

    # Use https://lazamar.co.uk/nix-versions/ to find nixpkgs revisions

    # Descriptive name to make the store path easier to identify
    name = "envoy-1.27.3";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "e89cf1c932006531f454de7d652163a9a5c86668";
  }) {
    inherit system;
    config.allowUnfree = true;
  };
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {
    services.envoy = {
      package = envoy_nixpkgs.envoy;
      enable = true;
    };
  };
}
