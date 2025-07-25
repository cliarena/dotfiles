{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["video=1920x1080" "i915.enable_guc=2"];

    initrd.kernelModules = ["i915"];
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "uas" "usb_storage"];

    kernel.sysctl = {"vm.swappiness" = 10;};

    loader = {
      timeout = 1;
      efi = {canTouchEfiVariables = true;};
      systemd-boot.enable = true;
    };
  };
}
