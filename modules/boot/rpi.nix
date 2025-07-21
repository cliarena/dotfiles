{pkgs, ...}: let
  raspberrypifw = pkgs.raspberrypifw.overrideAttrs {
    version = "pinned-2023.05.12";
    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "firmware";
      rev = "b49983637106e5fb33e2ae60d8c15a53187541e4";
      hash = "sha256-Ia+pUTl5MlFoYT4TrdAry0DsoBrs13rfTYx2vaxoKMw=";
    };
  };
  upstreamOverlay = name: raspberrypifw + /share/raspberrypi/boot/overlays/${name}.dtbo;
in {
  hardware.deviceTree = {
    enable = true;
    dtbSource = pkgs.device-tree_rpi.override {inherit raspberrypifw;};
    filter = "bcm2711-rpi-4-b.dtb";
    name = "broadcom/bcm2711-rpi-4-b.dtb";
    overlays = [
      {
        name = "upstream-pi4";
        dtboFile = upstreamOverlay "upstream-pi4";
      }
    ];
  };
  hardware.graphics.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelParams = [ "video=1920x1080" ];
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "uas" "usb_storage"];
    initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
    kernelModules = [
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    loader = {
      timeout = 1;
      efi = {canTouchEfiVariables = true;};
      systemd-boot.enable = true;
    };
  };
}
