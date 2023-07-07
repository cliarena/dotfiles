# Installation Guide

1. initial install using USB with nixos installer
    - set password for target machine to be able to reach it whith SSH `passwd`
    - use nixos-anywhere to deploy 
    `nix run github:numtide/nixos-anywhere -- --flake '.#svr' nixos@target_server_ip`
    - format disk with
    `sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode zap_create_mount ./modules/disko.nix --arg disks '[ "/dev/sda" ]'`
