{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_venn";
  description = "draw ASCII diagrams";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [venn-nvim];

      extraConfigLua = ''
        function _G.Toggle_vertualEdit()
           local venn_enabled = vim.inspect(vim.b.venn_enabled)
           if venn_enabled == "nil" then
             vim.b.venn_enabled = true
             vim.cmd[[setlocal ve=all]]
           else
             vim.cmd[[setlocal ve=]]
             vim.b.venn_enabled = nil
           end
         end
      '';
    };
  };
}
