{ ... }: {
  imports = [ ../../modules/boot.nix ../../modules/users.nix ];
  system.stateVersion = "22.11";
}
