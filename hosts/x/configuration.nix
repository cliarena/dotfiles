{ inputs, ... }:
let inherit (inputs) disko kmonad home-manager;
in {

  imports = [
    disko.nixosModules.disko
    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager
    ../../modules/nix_config.nix
    (import ../../modules/disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/fonts
    # ../../modules/video_acceleration.nix
    ../../modules/display_manager.nix
    ../../modules/hyprland.nix
    ../../modules/i18n.nix
    ../../modules/pipewire.nix
    ../../modules/network.nix
    ../../modules/kmonad
    ../../modules/pkgs.nix
    ../../modules/chromium.nix
  ];
  system.stateVersion = "22.11";
}
