{ pkgs, ... }: {
  hardware = {
    cpu.amd.updateMicrocode = true; # Maybe it fixed TTY scale issue
    enableRedistributableFirmware = true; # to detect wireless interfaces
    opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        ];
    };
    };
}
