{ lib, inputs, pkgs, ... }:
let
  inherit (inputs) sops-nix disko black-hosts nixvim microvm comin impermanence;
in {
  imports = [
    disko.nixosModules.disko

    black-hosts.nixosModule

    (import ./disko.nix { }) # doesn't support btrfs swapfile

    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/netwoking/router.nix
    ../../containers/desktop.nix
    ../../containers/dev_space.nix
    # ../../containers/vault_unsealer.nix

  ] ++ lib.fileset.toList ../../profiles;

  profiles.host.enable = true;
  profiles.common.enable = true;
  profiles.hosting.enable = true;

  _sshd.enable = true;

  environment.systemPackages = with pkgs; [
    ### Streaming ###
    inputs.wolf.packages.x86_64-linux.default
    ### Virtualization ###
    virtiofsd # needed by microvm jobs to use virtiofs shares
  ];
}
