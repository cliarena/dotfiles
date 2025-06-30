{ pkgs, ... }: {
  hardware.deviceTree = {
    enable = true;
    dtbSource = pkgs.device-tree_rpi;
    filter = "*rpi-4-*.dtb";
  };
  hardware.graphics.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
   # kernelParams = [ "video=1920x1080" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
    initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
    kernelModules = [
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    loader = {
      timeout = 1;
      efi = { canTouchEfiVariables = true; };
      systemd-boot.enable = true;
    };
  };

}
