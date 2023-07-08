# Installation Guide

1. initial install using USB with nixos installer
    - set password for target machine to be able to reach it whith SSH `passwd`
    - use nixos-anywhere to deploy 
    `nix run github:numtide/nixos-anywhere -- --flake '.#svr' nixos@target_server_ip`
    - format disk with
    `sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode zap_create_mount ./modules/disko.nix --arg disks '[ "/dev/sda" ]'`
    - clone repo 
    -- `nix-shell -p git`
    -- `git clone git@gitlab.com:cliarena_dotfiles/nixos`
    -- add age.key to secrets folder
    - install it `sudo nixos-install --flake .#host`

2. subsequent installs ` sudo nixos-rebuild switch --flake .#`

3. unseal VAULT using sops keys
    - Vault is auto initialized by vaul_initializer
    - the keys are saved in `/srv/vault/init.keys`
    - create sops secrets out of them
    - `cat ../.sops/secrets/VAULT_UNSEAL_KEY_1 | xargs vault operator unseal`
    - be aware xargs do put its aguments into the process table

4. login to VAULT: 
    -- nushell: `for $x in 1..3 { cat $"../.sops/secrets/VAULT_UNSEAL_KEY_($x)" | xargs vault operator unseal }`

5. setup CONSUL:
    - generate UUID for `CONSUL_HTTP_TOKEN`: `uuidgen` and save it as a sops secret
