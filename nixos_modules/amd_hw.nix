{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_amd_hw";
  description = "AMD Hardware";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = with pkgs; [ amdgpu_top ];
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

  };
}
