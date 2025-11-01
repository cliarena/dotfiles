{disks ? ["/dev/sda"], ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                # label = "ESP";
                mountpoint = "/boot";
                #  extraArgs = [ "-n ESP" ];
                #  device = "/dev/disk/by-partlabel/ESP";
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "btrfs";
                # label = "NIXOS";
                # extraArgs = [ "-n NIXOS" ]; # Override existing partition
                # device = "/dev/disk/by-partlabel/NIXOS";
                subvolumes = {
                  # Mountpoints inferred from subvolume name
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime" "noexec"];
                  };
                  "/srv" = {
                    mountpoint = "/srv";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    mountOptions = ["compress=zstd" "noatime" "noexec"];
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=6G" # limit tmpfs size to 6GiB
        "noatime"
        "mode=755"
      ];
    };
  };
}
