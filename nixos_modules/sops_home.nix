{
  config,
  lib,
  inputs,
  host,
  ...
}: let
  module = "_sops_home";
  description = "secrets for home users";
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (inputs) home-manager sops-nix;
in {
  imports = [home-manager.nixosModules.home-manager];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    home-manager.users.${host.user} = {config, ...}: let
      inherit (config.home) homeDirectory;
    in {
      imports = [sops-nix.homeManagerModules.sops];
      sops = {
        defaultSopsFile = ../secrets/${host.user}.yaml;
        age.keyFile = "/srv/secrets/SOPS_AGE_KEY";

        # Must set to empty list for age keyfile to work
        age.sshKeyPaths = mkForce [];
        gnupg.sshKeyPaths = mkForce [];

        # must set when used with home-manager
        defaultSymlinkPath = "${homeDirectory}/.sops/secrets";
        defaultSecretsMountPoint = "${homeDirectory}/.sops/secrets.d";

        secrets = {
          AGE_SECRET_KEY = {
            sopsFile = ../secrets/default.yaml;
            path = "${homeDirectory}/.config/sops/age/keys.txt";
          };
          PI_SSH_KEY = {sopsFile = ../secrets/ssh.yaml;};
          SVR_SSH_KEY = {sopsFile = ../secrets/ssh.yaml;};
          DS_SSH_KEY = {sopsFile = ../secrets/ssh.yaml;};
          GL_SSH_KEY = {sopsFile = ../secrets/ssh.yaml;};
          GH_SSH_KEY = {sopsFile = ../secrets/ssh.yaml;};

          VAULT_ROOT_TOKEN = {sopsFile = ../secrets/vault.yaml;};
          VAULT_UNSEAL_KEY_1 = {sopsFile = ../secrets/vault.yaml;};
          VAULT_UNSEAL_KEY_2 = {sopsFile = ../secrets/vault.yaml;};
          VAULT_UNSEAL_KEY_3 = {sopsFile = ../secrets/vault.yaml;};
          VAULT_UNSEAL_KEY_4 = {sopsFile = ../secrets/vault.yaml;};
          VAULT_UNSEAL_KEY_5 = {sopsFile = ../secrets/vault.yaml;};
        };
      };
    };
  };
}
