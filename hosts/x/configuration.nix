{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) disko;
in {
  imports =
    [
      disko.nixosModules.disko

      # (import ./disko.nix {inherit pkgs;}) # doesn't support btrfs swapfile
       ./disko.nix  # doesn't support btrfs swapfile
      ../../modules/boot/rpi.nix
      #    ../../modules/hardware/intel.nix
      ../../modules/netwoking/network.nix
    ]
    ++ lib.fileset.toList ../../profiles;

  environment.systemPackages = with pkgs; [libraspberrypi stress];

  #  boot.loader.grub.enable= false;
  #  boot.loader.generic-extlinux-compatible.enable = true;

    _nix.enable = true;
    _users.enable = true;
    _local.enable = true;

  profiles.host.enable = true;
  # profiles.common.enable = true;
  # profiles.desktop.enable = true;

  #  _kmonad.enable = true;
  #  _sddm.enable = true;

  # _gaming.enable = true;
  # _ankama.enable = true;
}
