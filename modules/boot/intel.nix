{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=1920x1080" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };
}
