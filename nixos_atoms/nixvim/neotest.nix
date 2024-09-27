{ config, lib, ... }:
let
  module = "_neotest";
  deskription = "instant inline tests";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.neotest = {
      enable = true;
      adapters.zig.enable = true;
      settings = {
        summary.mappings = {
          next_failed = "U";
          output = "o";
          prev_failed = "E";
          run = "r";
          run_marked = "R";
        };
      };
    };

  };
}
