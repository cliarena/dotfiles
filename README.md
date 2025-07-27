
# TODO:
- [ ] setup beesd for deduplication
- [ ] setup system & services monitoring
- [ ] Optimize power consumption


# Testing docker image

 - `sudo podman rmi -f nixos; nix build; cp result/tarball/nixos-system-x86_64-linux.tar.xz ../img.tar.xz; unxz -f ../img.tar.xz; rm -rf result; sudo podman import ../img.tar nixos; rm ../img.tar`


# Installation Guide

1. initial install using USB with nixos installer
    - set password for target machine to be able to reach it whith SSH `passwd`
    - use nixos-anywhere to deploy
    `nix run github:numtide/nixos-anywhere -- --flake '.#svr' nixos@target_server_ip`
    - format disk with
    `sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:nix-community/disko -- --mode zap_create_mount ./hosts/svr/disko.nix --arg disks '[ "/dev/sda" ]'`
    - clone repo
    -- `sudo scp ../.sops/secrets/AGE_SECRET_KEY nixos@10.10.0.102:age.key`
    -- `nix-shell -p git`
    -- `git clone https://gitlab.com/cliarena_dotfiles/nixos`
    -- add age.key to secrets folder

2. Disable Consul TLS encryption by commenting TLS block and rebuild
    - Because it needs agent certs from vault which needs to be configured using terranix
    which itself uses consul as its backend
    - sometimes rebuild fails because of vaul_initializer. don't worry just rebuild again and it will work

3. install it `sudo nixos-install --flake .#host`
    - subsequent installs ` sudo nixos-rebuild switch --flake .#`

4. unseal VAULT using sops keys
    - Vault is auto initialized by vaul_initializer
    - the keys are saved in `/srv/vault/init.keys`
    - create sops secrets out of them
    - unseal with:
        - nushell: `for $x in 1..3 { cat $"../.sops/secrets/VAULT_UNSEAL_KEY_($x)" | xargs vault operator unseal }`
    - be aware xargs do put its aguments into the process table

5. login to VAULT:
    - `cat ../.sops/secrets/VAULT_ROOT_TOKEN | xargs vault login`

6. Creat AppRole token for terranix
    - `vault policy write terranix ./modules/hashi_stack/vault/policies/terranix.hcl`
    - check if it's created: `vault policy list`, `vault policy read terranix`
    - `vault auth enable approle`
    - `vault write auth/approle/role/terranix token_ttl=20m policies="default,terranix"`
    - `vault read auth/approle/role/terranix/role-id`
    - save it in terranix default.nix `vault.terraform_approle_id`
    - Constrain role-id to only be usable by specefic machine so you don't need secret-id
    --- Constrained role-id > using secret-id
    --- `vault write auth/approle/role/terranix bind_secret_id=false secret_id_bound_cidrs=127.0.0.1/24` change `secret_id_bound_cidrs` to the source address shown when running `nix run .#apply` but append /8
    ---- most of the time this is enough from personal experience `172.0.0.1/8,168.0.0.1/8,188.0.0.1/8`
    ---- it fails some time because source address changes
    --- otherwise `vault write -f auth/approle/role/terranix/secret-id` save it somewhre safe
    -- set or adjust policies with `vault write  auth/approle/role/terranix/policies  policies="default,terranix,..."`
    - Check if terranix approle is set correctly `vault read auth/approle/role/terranix`

6. Creat AppRole token for Consul connect
    - `vault policy write consul ./modules/hashi_stack/vault/policies/consul.hcl`
    - check if it's created: `vault policy list`, `vault policy read consul`
    - `vault write auth/approle/role/consul  policies="consul"`
    - `vault read auth/approle/role/consul/role-id`
    - save it as sops secret `CONSUL_VAULT_ROLE_ID`
    - `vault write -f auth/approle/role/consul/secret-id` save it somewhre safe
    - save it as sops secret `CONSUL_VAULT_SECRET_ID`
    - set or adjust policies with `vault write  auth/approle/role/consul/policies  policies="default,consul,..."`
    - Check if consul approle is set correctly `vault read auth/approle/role/consul`

7. apply terranix config `CONSUL_HTTP_TOKEN=<global_management_token> nix run .#apply --impure`

8. run `consul reload` for ACLs to take effect

9. enable TLS. and rebuild

10. run `nix run .#apply` to finish basic setup of consul and vault
