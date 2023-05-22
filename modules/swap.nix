{ ... }: {

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  #swapDevices = [{
  #  device = "/swap/swapfile";
  #  size = (1000 * 16); # 16 GiB
  #}];

}
