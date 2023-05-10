{ ... }: {
  imports = [
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/display_manager.nix
    ../../modules/pkgs.nix
  ];
  system.stateVersion = "22.11";
}
