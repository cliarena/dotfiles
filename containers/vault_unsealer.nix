{ inputs, nixpkgs, ... }:
let
  host.user = "x";
  inherit (inputs) home-manager sops-nix;
in {
  containers.vault-unsealer = {
    autoStart = true;
    ephemeral = true;

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.11";
      _module.args.host = host;

      imports = [
        home-manager.nixosModules.home-manager
        {
          inherit nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${host.user} = {
            # imports = [ sops-nix.homeManagerModules.sops ../hosts/x/sops.nix ];
            home = {
              stateVersion = "22.11";
              username = host.user;
              homeDirectory = "/home/${host.user}";
            };
          };
        }
      ];

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
