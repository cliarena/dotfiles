{ ... }: {
  programs.git = {
    enable = true;
    userName = "CLI Arena";
    userEmail = "git@cliarena.com";
    signing.signByDefault = true;
    signing.key =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDppFak0qD2HXu9mtYXfrjzKFqPFtKzzmnBP5dNQr4Me GitLab";
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
  };
}
