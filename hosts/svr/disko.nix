{ disks ? [ "/dev/sda" ], ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-n boot" ];
              };
            };
            nixos = {
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
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=24G" # limit tmpfs size to 24GiB
        "noatime"
        # "noexec"
        "mode=755"
      ];
    };
  };
}
