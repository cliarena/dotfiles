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
      disabledKeys = {
        "<Down>" = [];
        "<Left>" = [];
        "<Right>" = [];
        "<Up>" = [];
};
      restrictedKeys = {

        "+" = [ "n" "x" ];
        "-" = [ "n" "x" ];

        "<C-M>" = [ "n" "x" ];
        "<C-N>" = [ "n" "x" ];
        "<C-P>" = [ "n" "x" ];
        "<CR>" = [ "n" "x" ];

        w = [ "n" "x" ];

        # "<Down>" = [ "n" "x" "i" ];
        # "<Left>" = [ "n" "x" "i" ];
        # "<Right>" = [ "n" "x" "i" ];
        # "<Up>" = [ "n" "x" "i" ];

      };
      # };

    };
  };

}
