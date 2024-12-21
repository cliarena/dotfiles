{ config, lib, pkgs, ... }:
let
  module = "_bench";
  description = "Benchmarking suite";
  inherit (lib) mkEnableOption mkIf;

in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    environment.systemPackages = [ pkgs.phoronix-test-suite ];
  };
}
