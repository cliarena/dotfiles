{ inputs, lib, pkgs, ... }:
let inherit (inputs) disko kmonad home-manager nixvim comin;
in {

  imports = [
    nixvim.nixosModules.nixvim
    disko.nixosModules.disko
    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager

    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/boot/intel.nix
    ../../modules/hardware/intel.nix
    ../../modules/display_manager.nix
    # ../../modules/gnome.nix
    ../../modules/hyprland.nix
    ../../modules/pipewire.nix
    ../../modules/netwoking/network.nix
    ../../modules/kmonad
    # ../../modules/pkgs.nix
    (import ../../modules/pkgs.nix { inherit inputs pkgs; })
    ../../modules/chromium.nix
    ../../modules/podman.nix
    # ../../modules/extra_containers.nix
    # ../../containers/dev_space-intel.nix
  ] ++ lib.fileset.toList ../../profiles;

  profiles.common.enable = true;
  profiles.coding.enable = true;

  system.stateVersion = "22.11";
  programs.nixvim = import ../../modules/nixvim pkgs;
}
