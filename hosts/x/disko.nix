{
  # pkgs,
  # disks ? ["/dev/sda"],
  ...
}: let
   disk = "/dev/sda";
  config_txt =pkgs: pkgs.writeText "config.txt" ''
    [pi4]
    kernel=u-boot-rpi4.bin
    enable_gic=1
    disable_overscan=1

    [all]
    arm_64bit=1
    enable_uart=1
    avoid_warnings=1
    dtoverlay=vc4-kms-v3d
  '';
  boot_folder =/. + (pkgs:  "${pkgs.raspberrypifw}/share/raspberrypi/boot");
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device =  disk;
        # device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            firmware = {
              # start = "2M";
              size = "30M";
              priority = 1;
              type = "0700";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/firmware";
                # postMountHook =pkgs: toString (pkgs.writeScript "postMountHook.sh" ''
                # postMountHook =pkgs:  pkgs.writeScript "postMountHook.sh" ''
                #   (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf *.dtb /mnt/firmware)
                #   cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin /mnt/firmware/u-boot-rpi4.bin
                #   cp ${config_txt} /mnt/firmware/config.txt
                # '';
                postMountHook =  ''
                   (cd ${boot_folder} && cp bootcode.bin fixup*.dat start*.elf *.dtb /mnt/firmware)
                '';
                #  extraArgs = [ "-n boot" ];
                #  device = "/dev/sda1";
              };
            };
            boot = {
              # start = "2M";
              size = "1G";
              # priority =1;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                #  extraArgs = [ "-n boot" ];
                #  device = "/dev/sda1";
              };
            };
            nixos = {
              # start = "512M";
              #  end = "100%";
              size = "100%";
              content = {
                type = "btrfs";
                #    extraArgs = [ "--label nixos" ]; # Override existing partition
                #    device = "/dev/sda2";
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
