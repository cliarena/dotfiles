{
  config,
  lib,
  ...
}: let
  module = "_yanky";
  description = "better yanking";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.yanky = {enable = true;};
  };
}
