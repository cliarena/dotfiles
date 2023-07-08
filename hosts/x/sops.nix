{ config, host, ... }:
let inherit (config.home) homeDirectory;
in {
  sops = {
    defaultSopsFile = ../../secrets/${host.user}.yaml;
    age.keyFile = ../../secrets/age.key;

    # must set when used with home-manager 
    defaultSymlinkPath = "${homeDirectory}/.sops/secrets";
    defaultSecretsMountPoint = "${homeDirectory}/.sops/secrets.d";
    secrets = {
      AGE_SECRET_KEY = {
        sopsFile = ../../secrets/default.yaml;
        path = "${homeDirectory}/.config/sops/age/keys.txt";
      };
      PI_SSH_KEY = { sopsFile = ../../secrets/ssh.yaml; };
      GL_SSH_KEY = { sopsFile = ../../secrets/ssh.yaml; };
      SVR_SSH_KEY = { sopsFile = ../../secrets/ssh.yaml; };

      VAULT_ROOT_TOKEN = { sopsFile = ../../secrets/vault.yaml; };
      VAULT_UNSEAL_KEY_1 = { sopsFile = ../../secrets/vault.yaml; };
      VAULT_UNSEAL_KEY_2 = { sopsFile = ../../secrets/vault.yaml; };
      VAULT_UNSEAL_KEY_3 = { sopsFile = ../../secrets/vault.yaml; };
      VAULT_UNSEAL_KEY_4 = { sopsFile = ../../secrets/vault.yaml; };
      VAULT_UNSEAL_KEY_5 = { sopsFile = ../../secrets/vault.yaml; };
    };
  };

}
