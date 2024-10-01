{ config, lib, system, ... }:
let
  module = "_neotest";
  deskription = "instant inline tests";
  inherit (lib) mkEnableOption mkIf;
  old_pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "05bbf675397d5366259409139039af8077d695ce";
  }) { inherit system; };

  old_neotest_pkg = old_pkgs.vimPlugins.neotest;
  old_neotest-zig_pkg = old_pkgs.vimPlugins.neotest-zig;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.neotest = {
      enable = true;
      package = old_neotest_pkg;

      adapters.zig = {
        enable = true;
        package = old_neotest-zig_pkg;
        settings.dap.adapter = "lldb";
      };

      settings = {
        summary.mappings = {
          next_failed = "U";
          output = "o";
          prev_failed = "E";
          run = "r";
          run_marked = "R";
        };
        watch = {
          enable = true;
          symbol_queries = { zig = ""; };
        };
      };
    };

  };
}
