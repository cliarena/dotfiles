{ lib, ... }:
let host.user = "x";
in {
  containers.vault-unsealer = {

    autoStart = true;
    ephemeral = true;
    specialArgs = { inherit host; };

    config = { pkgs, ... }: {

      imports = lib.fileset.toList ../nixos_modules;

      _home.enable = true;
      _sops_home.enable = true;

      users.users.${host.user} = { isNormalUser = true; };
      services.getty.autologinUser = host.user;

      systemd.services.vault_unsealer = {
        path = [ pkgs.getent pkgs.vault-bin ];
        description = "Vault unsealer";
        environment = { VAULT_ADDR = "https://vault.cliarena.com:8200"; };
        script = ''
          for i in {1..3}
          do
             cat /home/${host.user}/.sops/secrets/VAULT_UNSEAL_KEY_$i | xargs vault operator unseal
          done
        '';
        serviceConfig = {
          Restart = "on-failure";
          # avoid error start request repeated too quickly since RestartSec defaults to 100ms
          RestartSec = 3;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
