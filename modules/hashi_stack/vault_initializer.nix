{ pkgs, VAULT_ADDR, ... }:
let vault_bin = "${pkgs.vault}/bin/vault";
in {

  systemd.services.vault_initializer = {
    path = [ pkgs.getent ];
    environment = { inherit VAULT_ADDR; };
    description = "auto initialize vault";
    script = ''
      ${vault_bin} operator init | tee /srv/vault/init.keys
    '';
    wantedBy = [ "vault.service" "consul.service" ];
    partOf = [ "vault.service" "consul.service" ];
    after = [ "vault.service" "consul.service" "sops-nix.service" ];
  };
}
