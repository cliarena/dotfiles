{ disks ? [ "/dev/vdb" ], ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "root";
              start = "512MiB";
              end = "100%";
              content = {
                type = "btrfs";
                # extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  # Mountpoints inferred from subvolume name
                  "/nix" = { mountOptions = [ "compress=zstd" "noatime" ]; };
                  "/var/log" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/srv" = { mountOptions = [ "compress=zstd" "noatime" ]; };
                  "/swap" = { mountOptions = [ "compress=zstd" "noatime" ]; };
                };
              };
            }
          ];
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=2GiB" # limit tmpfs size to 2GiB
        "noatime"
        "mode=755"
      ];
    };
  };
}
