{ disks ? [ "/dev/sda" ], ... }: {
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
                extraArgs = [ "-n boot" ];
              };
            }
            {
              name = "nixos";
              start = "512MiB";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "--label nixos" ]; # Override existing partition
                subvolumes = {
                  # Mountpoints inferred from subvolume name
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" "noexec" ];
                  };
                  "/acme" = {
                    mountpoint = "/var/lib/acme";
                    mountOptions = [ "compress=zstd" "noatime" "noexec" ];
                  };
                  # "/nomad" = {
                  # mountpoint = "/var/lib/nomad";
                  # mountOptions = [ "compress=zstd" "noatime" "noexec" ];
                  # };
                  "/srv" = {
                    mountpoint = "/srv";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "compress=zstd" "noatime" "noexec" ];
                  };
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
        "size=6G" # limit tmpfs size to 6GiB
        "noatime"
        # "noexec"
        "mode=755"
      ];
    };
  };
}
