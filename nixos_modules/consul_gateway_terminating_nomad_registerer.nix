# NOTE: Exposes api-gateway port. otherwise you gateway is useless

{ config, lib, pkgs, system, host, ... }:

let
  module = "_consul_gateway_terminating_nomad_registerer";
  description = "registers consul nomad terminating gateway";
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

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    systemd.services.consul_gateway_terminating_nomad_registerer = {
      path = [ pkgs.getent pkgs.envoy ];
      description = "register consul nomad terminating gateway";
      script = ''
        ${pkgs.consul}/bin/consul connect envoy -gateway terminating -register -service nomad-gateway  -admin-bind ${host.ip_addr}:19001 -address ${host.ip_addr}:4649 -ignore-envoy-compatibility
        # ${pkgs.consul}/bin/consul connect envoy -gateway terminating -register -service nomad-client-gateway  -address ${host.ip_addr}:4649 -ignore-envoy-compatibility
        # ${pkgs.consul}/bin/consul connect envoy -sidecar-for nomad-client -bootstrap -ignore-envoy-compatibility
      '';
      serviceConfig = {
        Restart = "on-failure";
        # avoid error start request repeated too quickly since RestartSec defaults to 100ms
        RestartSec = 3;
      };
      wantedBy = [ "vault.service" "consul.service" ];
      partOf = [ "vault.service" "consul.service" ];
      after = [ "vault.service" "consul.service" ];
    };
  };
}
