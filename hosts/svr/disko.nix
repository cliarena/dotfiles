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
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = ["-n boot"];
                device = "/dev/disk/by-partlabel/ESP";
              };
            };
            nixos = {
              start = "512M";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["--label nixos"]; # Override existing partition
                device = "/dev/disk/by-partlabel/nixos";
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
                  "/acme" = {
                    mountpoint = "/var/lib/acme";
                    mountOptions = ["compress=zstd" "noatime" "noexec"];
                  };
                  # "/nomad" = {
                  # mountpoint = "/var/lib/nomad";
                  # mountOptions = [ "compress=zstd" "noatime" "noexec" ];
                  # };
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
        "size=96G" # limit tmpfs size to 24GiB
        "noatime"
        # "noexec"
        "mode=755"
      ];
    };
  };
  fileSystems."/srv".neededForBoot = true; # needed by impermanence
}
