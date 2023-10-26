{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=1920x1080" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
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
