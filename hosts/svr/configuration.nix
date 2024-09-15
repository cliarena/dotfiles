{ lib, inputs, pkgs, ... }:
let
  inherit (inputs) sops-nix disko black-hosts nixvim microvm comin impermanence;
in {
  imports = [
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence

    comin.nixosModules.comin
    nixvim.nixosModules.nixvim
    sops-nix.nixosModules.sops
    black-hosts.nixosModule
    # microvm.nixosModules.microvm
    microvm.nixosModules.host

    ./sops.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ./impermanence.nix

    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/corectrl.nix
    ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hydra.nix
    ../../modules/hashi_stack
    ../../modules/extra_containers.nix
    ../../containers/hello.nix
    ../../containers/desktop.nix
    ../../containers/dev_space.nix
    ../../containers/vault_unsealer.nix
    ../../containers/wolf_desktop.nix
    ../../microvms/test.nix
    # ../../modules/pkgs.nix
    (import ../../modules/pkgs.nix { inherit inputs pkgs; })
    # doesn't support btrfs swapfile
    # ../../modules/surrealdb.nix

    # Observability
    # ../../modules/victoriametrics.nix
  ] ++ lib.fileset.toList ../../profiles;

  profiles.common.enable = true;

  programs.nixvim = import ../../modules/nixvim pkgs;

  environment.systemPackages = with pkgs;
    [
      ### Streaming ###
      inputs.wolf.packages.x86_64-linux.default
    ];
  system.stateVersion = "22.11";
}
