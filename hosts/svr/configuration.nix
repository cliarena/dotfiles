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
    ../../modules/hardware/amd.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    # ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
    ../../containers/dev_space.nix
    ../../containers/hello.nix
  ];
  system.stateVersion = "22.11";
}
