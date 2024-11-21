{ pkgs, ... }: {
  hardware = {
    cpu.intel.updateMicrocode = true; # Maybe it fixed TTY scale issue
    enableRedistributableFirmware = true; # to detect wireless interfaces
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
  # Enable Intel hybrid driver
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  # Native Wayland support for GPU acceleration
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # For Intel gpu acceleration
  environment.variables.LIBVA_DRIVER_NAME = "i915"; # This
  # environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD"; # or This
}
