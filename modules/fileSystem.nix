{ config, ... }: {

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/nixos";
  #     fsType = "ext4";
  #   };
  services.fstrim.enable = true;
  fileSystems = {

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "mode=755" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

    # "/etc" = {
    #   device = "/dev/disk/by-label/nixos";
    #   fsType = "btrfs";
    #   options = [ "subvol=@etc" "compress=zstd" "noatime" ];
    # };

    "/var/log" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@log" "compress=zstd" "noatime" ];
    };

    # "/var/lib" = {
    #   device = "/dev/disk/by-label/nixos";
    #   fsType = "btrfs";
    #   options = [ "subvol=@lib" "compress=zstd" "noatime" ];
    # };
    #
    # "/root" = {
    #   device = "/dev/disk/by-label/nixos";
    #   fsType = "btrfs";
    #   options = [ "subvol=@root" "compress=zstd" "noatime" ];
    # };
    #
    # "/vault/ssd" = {
    #   device = "/dev/disk/by-label/nixos";
    #   fsType = "btrfs";
    #   options = [ "subvol=@data" "compress=zstd" "noatime" ];
    # };
    #
    # "/vault/hdd" = {
    #   device = "/dev/disk/by-label/vault";
    #   fsType = "btrfs";
    #   options = [ "subvol=@data" "compress=zstd" "noatime" ];
    # };
    #
    # "/vault/.snapshots/ssd" = {
    #   device = "/dev/disk/by-label/nixos";
    #   fsType = "btrfs";
    #   options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
    # };
    #
    # "/vault/.snapshots/hdd" = {
    #   device = "/dev/disk/by-label/vault";
    #   fsType = "btrfs";
    #   options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
    # };

    "/srv" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@srv" "compress=zstd" "noatime" ];
    };
    "/swap" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@swap" "compress=zstd" "noatime" ];
    };

    # Enable if tmp keeps making OOM
    # "/tmp" = {
    #   device = "/dev/disk/by-label/data";
    #   fsType = "btrfs";
    #   options = [ "subvol=tmp" ];
    # };
  };
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  swapDevices = [{
    device = "/swap/swapfile";
    size = (1000 * 16); # 16 GiB
  }];

}
