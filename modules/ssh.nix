{ config, ... }: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host gitlab.com
        PreferredAuthentications publickey
        IdentityFile  ${config.sops.secrets.GL_SSH_KEY.path}
    '';
  };
}
