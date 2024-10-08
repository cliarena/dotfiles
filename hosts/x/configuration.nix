{ inputs, lib, pkgs, ... }:
let inherit (inputs) disko kmonad home-manager nixvim comin;
in {

  imports = [
    disko.nixosModules.disko
    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager

    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/boot/intel.nix
    ../../modules/hardware/intel.nix
    ../../modules/display_manager.nix
    ../../modules/hyprland.nix
    ../../modules/pipewire.nix
    ../../modules/netwoking/network.nix
    ../../modules/kmonad
    ../../modules/chromium.nix
  ] ++ lib.fileset.toList ../../profiles;

  profiles.host.enable = true;
  profiles.common.enable = true;
  profiles.desktop.enable = true;
}
