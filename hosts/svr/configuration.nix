{ inputs, pkgs, ... }:
let inherit (inputs) sops-nix disko black-hosts;
in {
  imports = [
    sops-nix.nixosModules.sops
    disko.nixosModules.disko
    black-hosts.nixosModule
    ./sops.nix
    ../../modules/nix_config.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/corectrl.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
    ../../containers/dev_space.nix
    ../../containers/hello.nix
    ../../modules/pkgs.nix
  ];
  programs.nixvim = import ../../modules/nixvim pkgs;
  system.stateVersion = "22.11";
}
