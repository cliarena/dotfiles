{ inputs, pkgs, ... }:
let inherit (inputs) sops-nix disko black-hosts nixvim microvm comin;
in {
  imports = [
    comin.nixosModules.comin
    nixvim.nixosModules.nixvim
    sops-nix.nixosModules.sops
    disko.nixosModules.disko
    black-hosts.nixosModule
    # microvm.nixosModules.microvm
    microvm.nixosModules.host

    ./sops.nix
    ../../modules/nix_config.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/corectrl.nix
    ../../modules/users.nix
    ../../modules/comin.nix
    ../../modules/i18n.nix
    ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
    ../../containers/dev_space.nix
    ../../containers/vault_unsealer.nix
    ../../containers/wolf_desktop.nix
    ../../containers/hello.nix
    ../../microvms/test.nix
    # ../../modules/pkgs.nix
    (import ../../modules/pkgs.nix { inherit inputs pkgs; })
    # doesn't support btrfs swapfile
    ../../modules/surrealdb.nix

    # Observability
    ../../modules/victoriametrics.nix
  ];
  programs.nixvim = import ../../modules/nixvim pkgs;
  system.stateVersion = "22.11";
}
