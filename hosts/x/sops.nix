{ config, user, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/x.yaml;
    age.keyFile = ../../secrets/age-key.txt;

    secrets = {
      AGE_SECRET_KEY = {
        sopsFile = ../../secrets/default.yaml;
        path = "home/${user}/.config/sops/age/keys.txt";
        owner = config.users.users.${user}.name;
        group = config.users.users.${user}.group;
      };
      PI_SSH_KEY = { sopsFile = ../../secrets/ssh.yaml; };
      GL_SSH_KEY = { sopsFile = ../../secrets/ssh.yaml; };
    };
  };

}
