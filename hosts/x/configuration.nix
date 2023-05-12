{ ... }: {
  imports = [
    ../../modules/nix_config.nix
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/display_manager.nix
    ../../modules/pkgs.nix
    ../../modules/i18n.nix
    ../../modules/pipewire.nix
    ../../modules/network.nix
    ../../modules/kmonad
  ];
  system.stateVersion = "22.11";
}
