{ config, lib, pkgs, ... }:
let
  module = "_venn";
  description = "draw ASCII diagrams";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    programs.nixvim = { extraPlugins = with pkgs.vimPlugins; [ venn-nvim ]; };
  };

}
