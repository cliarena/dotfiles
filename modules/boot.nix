{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=1920x1080" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
    kernelModules = [
      # need for nomad iptables
      "iptable_nat"
      "iptable_filter"
      "xt_nat"
      "xt_mark"
      "xt_comment"
      "xt_multiport"
    ];
    kernel.sysctl = { "vm.swappiness" = 10; };

    loader = {
      timeout = 1;
      efi = { canTouchEfiVariables = true; };
      systemd-boot.enable = true;
    };
  };

}
