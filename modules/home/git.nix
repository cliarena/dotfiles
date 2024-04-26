{ config, ... }: {
  programs.git = {
    enable = true;
    userName = "CLI Arena";
    userEmail = "git@cliarena.com";
    signing.signByDefault = true;
    # the private key of public key added to git instance to sign commits
    signing.key = config.sops.secrets.GL_SSH_KEY.path;
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
  };
}
