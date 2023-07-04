{ ... }: {
  imports = [
    ./sops.nix
    ../../modules/nix_config.nix
    (import ../../modules/disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ../../modules/sshd.nix
    ../../modules/network.nix
    ../../modules/auditd.nix
  ];
  system.stateVersion = "22.11";
}
