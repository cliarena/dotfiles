{ config, lib, ... }:
let
  module = "_swap";
  deskription = "swap";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

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
