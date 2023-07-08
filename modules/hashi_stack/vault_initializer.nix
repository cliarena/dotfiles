{ pkgs, VAULT_ADDR, ... }:
let vault_bin = "${pkgs.vault}/bin/vault";
in {

  systemd.services.vault_initializer = {
    path = [ pkgs.getent ];
    environment = { inherit VAULT_ADDR; };
    description = "auto initialize vault";
    script = ''
      init_keys="$(${vault_bin} operator init)"
       if [ -n "$init_keys" ]
        then
          echo "$init_keys" > /srv/vault/init.keys
        fi
    '';
    wantedBy = [ "vault.service" "consul.service" ];
    partOf = [ "vault.service" "consul.service" ];
    after = [ "vault.service" "consul.service" "sops-nix.service" ];
  };
}
