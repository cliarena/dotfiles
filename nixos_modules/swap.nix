{ config, lib, ... }:
let
  module = "_swap";
  description = "swap";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };
    #swapDevices = [{
    #  device = "/swap/swapfile";
    #  size = (1000 * 16); # 16 GiB
    #}];
  };

}
