{ ... }: {
  hardware.cpu.amd.updateMicrocode = true; # Maybe it fixed TTY scale issue
  hardware.enableRedistributableFirmware = true; # to detect wireless interfaces
}
