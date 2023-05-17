{ config, user, ... }:
let inherit (config.home) homeDirectory;
in {
  sops = {
    defaultSopsFile = ../../secrets/${user}.yaml;
    age.keyFile = ../../secrets/age-key.txt;

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
    };
  };

}
