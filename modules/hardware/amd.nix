{ ... }: {
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true; # to detect wireless interfaces
}
