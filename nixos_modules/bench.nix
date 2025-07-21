{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_bench";
  description = "Benchmarking suite";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = with pkgs; [
      phoronix-test-suite
      ryzen-monitor-ng
      i2c-tools # memory timings
    ];
  };
}
