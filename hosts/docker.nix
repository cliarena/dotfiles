{
  modulesPath,
config,
  lib,
  ...
}: {
  imports = [

    "${toString modulesPath}/image/file-options.nix"  
    "${toString modulesPath}/virtualisation/docker-image.nix"
  ];

    system.build.image = config.system.build.tarball;  # docker import-style rootfs
  image.extension = "tar.xz";  
  #   image.baseName = "nixos-docker";
  # boot.loader.grub.enable = lib.mkForce false;
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # services.journald.console = "/dev/console";

  # formatAttr = "tarball";
  # fileExtension = ".tar.xz";
}
