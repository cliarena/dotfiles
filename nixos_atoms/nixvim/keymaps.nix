{ config, lib, ... }:
let
  module = "_keymaps";
  deskription = "keymaps";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.keymaps = [
      # Navigation
      {
        action = "<Down>";
        key = "e";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Up>";
        key = "l";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Right>";
        key = "a";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "<Left>";
        key = "n";
        options = {
          silent = true;
          nowait = true;
        };
      }
    ];

  };

}
