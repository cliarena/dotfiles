{ pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  # Enable Intel hybrid driver
  # nixpkgs.config.packageOverrides = pkgs: {
  # vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  # };
  # Native Wayland support for GPU acceleration
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
