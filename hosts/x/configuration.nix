{ ... }: {
  imports = [
    ../../modules/nix_config.nix
    ../../modules/disko.nix # doesn't support btrfs swapfile
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/fonts
    ../../modules/display_manager.nix
    ../../modules/pkgs.nix
    ../../modules/i18n.nix
    ../../modules/pipewire.nix
    ../../modules/network.nix
    ../../modules/kmonad
  ];
  system.stateVersion = "22.11";
}
