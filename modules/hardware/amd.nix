{ pkgs, ... }: {
  # Fix HIP for most packages for video acceleration
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
