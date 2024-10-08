{ lib, inputs, pkgs, ... }:
let
  inherit (inputs) sops-nix disko black-hosts nixvim microvm comin impermanence;
in {
  imports = [
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence

    sops-nix.nixosModules.sops
    black-hosts.nixosModule

    ./sops.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ./impermanence.nix

    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
    ../../containers/desktop.nix
    ../../containers/dev_space.nix
    ../../containers/vault_unsealer.nix
    (import ../../modules/pkgs.nix { inherit inputs pkgs; })

    # Observability
    # ../../modules/victoriametrics.nix
  ] ++ lib.fileset.toList ../../profiles;

  profiles.host.enable = true;
  profiles.common.enable = true;
  profiles.hosting.enable = true;

  environment.systemPackages = with pkgs;
    [
      ### Streaming ###
      inputs.wolf.packages.x86_64-linux.default
    ];
}
