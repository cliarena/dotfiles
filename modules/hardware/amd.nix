{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
  hardware = {
    uinput.enable = true;
    steam-hardware.enable = true;
    cpu.amd.updateMicrocode = true; # Maybe it fixed TTY scale issue
    enableRedistributableFirmware = true; # to detect wireless interfaces
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
