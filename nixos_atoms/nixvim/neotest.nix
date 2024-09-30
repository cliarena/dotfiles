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
    rev = "0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb";
  }) { inherit system; };

  old_neotest-zig_pkg = old_pkgs.vimPlugins.neotest-zig;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.neotest = {
      enable = true;

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
