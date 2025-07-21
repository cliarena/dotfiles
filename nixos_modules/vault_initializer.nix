{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_vault_initializer";
  description = "auto vault initializer";
  inherit (lib) mkEnableOption mkIf;

  VAULT_ADDR = "http://10.10.0.10:8200";
  vault_bin = "${pkgs.vault}/bin/vault";
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    systemd.services.vault_initializer = {
      path = [pkgs.getent];
      environment = {inherit VAULT_ADDR;};
      description = "auto initialize vault";
      script = ''
        init_keys="$(${vault_bin} operator init)"
         if [ -n "$init_keys" ]
          then
            echo "$init_keys" > /srv/vault/init.keys
          fi
      '';
      wantedBy = ["vault.service" "consul.service"];
      partOf = ["vault.service" "consul.service"];
      after = [
        "vault.service"
        "consul.service"
        "sops-nix.service"
        "cloudflare-dyndns.service"
      ];
    };
  };
}
