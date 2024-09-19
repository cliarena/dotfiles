{ config, lib, ... }:
let
  module = "_lsp";
  deskription = "lsp";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        taplo.enable = true;
        nixd.enable = true;
        rust-analyser.enable = true;
        zls.enable = true;
      };
    };
  };

}
