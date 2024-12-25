{ pkgs, ... }: {
  # Fix HIP for most packages for video acceleration
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [ rocblas hipblas clr llvm ];
    };
  in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
  environment.systemPackages = with pkgs; [ amdgpu_top ];
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
  hardware = {
    uinput.enable = true;
    steam-hardware.enable = true;
    cpu.amd = {
      updateMicrocode = true; # Maybe it fixed TTY scale issue
      ryzen-smu.enable = true; # undervorling & overclocking
    };
    enableRedistributableFirmware = true; # to detect wireless interfaces
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
