{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_tracing_pkgs";
  description = "tracing_pkgs";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.bcc.enable = true;
    programs.sysdig.enable = !pkgs.stdenv.isAarch64;

    # allow perf as user
    boot.kernel.sysctl."kernel.perf_event_paranoid" = -1;
    boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkForce 0;

    # so perf can find kernel modules
    systemd.tmpfiles.rules = ["L /lib - - - - /run/current/system/lib"];

    environment.systemPackages = [
      pkgs.strace

      # we want to use trace from bcc
      (pkgs.lowPrio config.boot.kernelPackages.perf)
    ];
  };
}
