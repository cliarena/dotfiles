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
        key = "e";
        action = "j";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "k";
        key = "l";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "l";
        key = "a";
        options = {
          silent = true;
          nowait = true;
        };
      }
      {
        action = "h";
        key = "n";
        options = {
          silent = true;
          nowait = true;
        };
      }
    ];

  };

}
