{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=1920x1080" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [
      "uinput"
      "kvm-amd" # support virtual machine acceleration
      "intel_rapl_common" # needed by scaphandre prometheus exporter
      # need for nomad iptables
      "iptable_nat"
      "iptable_filter"
      "xt_nat"
      "xt_mark"
      "xt_comment"
      "xt_multiport"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      # set the kernel parameters necessary to let us forward packets
      ## TODO: only needed for router need to refactor to not add it to other hosts
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    loader = {
      timeout = 1;
      efi = { canTouchEfiVariables = true; };
      systemd-boot.enable = true;
    };
  };
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

}
