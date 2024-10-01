{ config, lib, ... }:
let
  module = "_hardtime";
  deskription = "quit bad vim habits";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.hardtime = {
      enable = true;
      # settings = {
      disabledKeys = { };
      restrictedKeys = {

        "+" = [ "n" "x" ];
        "-" = [ "n" "x" ];

        "<C-M>" = [ "n" "x" ];
        "<C-N>" = [ "n" "x" ];
        "<C-P>" = [ "n" "x" ];
        "<CR>" = [ "n" "x" ];

        l = [ "n" "x" ];
        e = [ "n" "x" ];
        n = [ "n" "x" ];
        a = [ "n" "x" ];

        "<Left>" = [ "" "i" ];
        "<Right>" = [ "" "i" ];

      };
      # };

    };
  };

}
