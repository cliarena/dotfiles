{ inputs, pkgs, ... }:
let inherit (inputs) disko kmonad home-manager nixvim comin;
in {

  imports = [
    comin.nixosModules.comin
    nixvim.nixosModules.nixvim
    disko.nixosModules.disko
    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager
    ../../modules/nix_config.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot/intel.nix
    ../../modules/users.nix
    ../../modules/comin.nix
    ../../modules/fonts
    ../../modules/hardware/intel.nix
    ../../modules/display_manager.nix
    # ../../modules/gnome.nix
    ../../modules/hyprland.nix
    ../../modules/i18n.nix
    ../../modules/pipewire.nix
    ../../modules/netwoking/network.nix
    ../../modules/kmonad
    # ../../modules/pkgs.nix
    (import ../../modules/pkgs.nix { inherit inputs pkgs; })
    ../../modules/chromium.nix
    ../../modules/podman.nix
    # ../../modules/extra_containers.nix
    # ../../containers/dev_space-intel.nix
  ];
  system.stateVersion = "22.11";
  programs.nixvim = import ../../modules/nixvim pkgs;
}
