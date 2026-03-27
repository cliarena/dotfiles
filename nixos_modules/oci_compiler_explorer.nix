{
  config,
  lib,
  ...
}:
let
  module = "_oci_compiler_explorer";
  description = "Godbolt Compiler Explorer";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    virtualisation.oci-containers.containers.compiler-explorer = {
      # privileged = true;
      image = "madduci/docker-compiler-explorer:latest";

      ports = [
        "10240:10240/tcp"
      ];

      volumes = [
        "/nix/store:/nix/store:ro" # to run nixos pkgs
        "/run/current-system/sw/bin:/usr/local/bin:ro" # to access zig pkg
        # "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs
      ];
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
