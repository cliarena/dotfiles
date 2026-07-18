{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_oci_huly";
  description = "Huly Project Manager";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    services.cockroachdb = {
      enable = true;
      insecure = true;
      extraArgs = [
        "--accept-sql-without-tls"
      ];
    };
    services.garage = {
      enable = true;
      package = pkgs.garage_2;
      settings = ''
        rpc_bind_addr = "[::]:3901"
      '';
    };
    services.elasticsearch = {
      enable = true;
      plugins = [ pkgs.elasticsearchPlugins.ingest-attachment ];
      extraConf = ''
        http.cors.enabled: true
        http.cors.allow-origin: "http://localhost:8082"
      '';
    };
    virtualisation.oci-containers.containers = {
      redpanda = {
        # privileged = true;
        image = "docker.redpanda.com/redpandadata/redpanda:v24.3.6";
        cmd = [
          "redpanda"
          "start"
          "--kafka-addr internal://0.0.0.0:9092,external://0.0.0.0:19092"
          "--advertise-kafka-addr internal://redpanda:9092,external://localhost:19092"
          "--pandaproxy-addr internal://0.0.0.0:8082,external://0.0.0.0:18082"
          "--advertise-pandaproxy-addr internal://redpanda:8082,external://localhost:18082"
          "--schema-registry-addr internal://0.0.0.0:8081,external://0.0.0.0:18081"
          "--rpc-addr redpanda:33145"
          "--advertise-rpc-addr redpanda:33145"
          "--mode dev-container"
          "--smp 1"
          "--default-log-level=info"
        ];
        environment = {
          REDPANDA_SUPERUSER_USERNAME = "x";
          REDPANDA_SUPERUSER_PASSWORD = "test";
        };

        ports = [
          # TODO: ADD Ports
          # "10000:10000/tcp"
        ];

        volumes = [
          "/var/lib/redpanda/data:/var/lib/redpanda/data:rw"
          # "/nix/store:/nix/store:ro" # to run nixos pkgs
          # "/run/current-system/sw/bin:/usr/local/bin:ro" # to access zig pkg
          # "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs
        ];
      };
    };

    # systemd.services.podman-wolf.serviceConfig = {
    #   # User = "root";
    #   Group = "pulse-access";
    #   Restart = "on-failure";
    #   TimeoutSec = 3;
    #   # avoid error start request repeated too quickly since RestartSec defaults to 100ms
    #   RestartSec = 3;
    # };
  };
}
