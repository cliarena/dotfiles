{ pkgs, ... }: {
  # Fix HIP for most packages for video acceleration
  # systemd.tmpfiles.rules = let
  #   rocmEnv = pkgs.symlinkJoin {
  #     name = "rocm-combined";
  #     paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
  #   };
  # in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
  hardware = {
    uinput.enable = true;
    steam-hardware.enable = true;
    cpu.amd.updateMicrocode = true; # Maybe it fixed TTY scale issue
    enableRedistributableFirmware = true; # to detect wireless interfaces
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs.rocmPackages; [ clr clr.icd ];
    };
  };
}
