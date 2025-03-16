{ config, lib, ... }:
let
  module = "hosting";
  description = "hosting profile";
  inherit (lib) mkEnableOption mkIf fileset;
in {

  imports = fileset.toList ../nixos_modules;

  options.profiles.${module}.enable = mkEnableOption description;

  config = mkIf config.profiles.${module}.enable {

    _sops_hosting.enable = true;

    _hydra.enable = true;
    _auditd.enable = true;
    _impermanence.enable = true;

    _acme.enable = true;
    _docker.enable = true;

    # _nats_system.enable = true;

    _vault.enable = true;
    _vault_initializer.enable = true;
    _vault_unsealer.enable = true;

    _envoy.enable = true;
    _consul.enable = true;
    _consul_api_gateway_registerer.enable = true;
    _consul_gateway_terminating_nomad_registerer.enable = true;

    _nomad.enable = true;

    _powerdns.enable = true;
    _cloudflare_dyndns.enable = true;

    _bench.enable = true;
    _tracing_pkgs.enable = true;
    _victoria_metrics.enable = true;

    _polaris.enable = true;
  };
}
