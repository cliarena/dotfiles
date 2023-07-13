{ ... }: {
  programs.git = {
    enable = true;
    userName = "CLI Arena";
    userEmail = "git@cliarena.com";
    extraConfig = { init.defaultBranch = "main"; };
  };
}
