{ config, lib, ... }:
let
  module = "_lsp";
  deskription = "lsp";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        taplo.enable = true;
        nixd.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        zls.enable = true;
      };
    };
  };

}
