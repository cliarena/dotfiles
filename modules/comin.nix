{ ... }: {
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://gitlab.com/cliarena_dotfiles/nixos";
      # This is an access token to access our private repository
      # auth.access_token_path = cfg.sops.secrets."gitlab/access_token".path;
      # No testing branch on this remote
      branches.testing.name = "";
    }];
  };

}
