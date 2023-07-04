{ ... }: {
  imports = [
    ../../modules/nix_config.nix
    (import ../../modules/disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/fonts
    # ../../modules/display_manager.nix
    # ../../modules/hyprland.nix
    ../../modules/i18n.nix
    # ../../modules/pipewire.nix
    ../../modules/network.nix
    ../../modules/kmonad
    # ../../modules/pkgs.nix
    ../../modules/auditd.nix
  ];
  system.stateVersion = "22.11";
}
