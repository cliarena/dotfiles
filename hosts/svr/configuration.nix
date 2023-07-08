{ inputs, ... }:
let inherit (inputs) sops-nix disko;
in {
  imports = [
    sops-nix.nixosModules.sops
    disko.nixosModules.disko
    ./sops.nix
    ../../modules/nix_config.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    # ../../modules/sshd.nix
    ../../modules/network.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
  ];
  system.stateVersion = "22.11";
}
