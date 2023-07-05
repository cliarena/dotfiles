{ config, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      pi = {
        host = "PI";
        hostname = "10.10.0.2";
        user = "pi";
        port = 4729;
        identityFile = config.sops.secrets.PI_SSH_KEY.path;
      };
      svr = {
        host = "SVR";
        hostname = "10.10.0.10";
        user = "svr";
        port = 4729;
        identityFile = config.sops.secrets.SVR_SSH_KEY.path;
      };
      gitlab = {
        host = "gitlab.com";
        identityFile = config.sops.secrets.GL_SSH_KEY.path;
        extraOptions = { PreferredAuthentications = "publickey"; };
      };
    };
  };
}
# Host gitlab.com
# PreferredAuthentications publickey
#  IdentityFile ~/.ssh/gitlab
