{ pkgs, user, ... }: {
  services.kmscon = {
    enable = true;
    autologinUser = user;
    fonts = [{
      name = "JetBrainsMono nerd font";
      package = pkgs.nerdfonts;
    }];
  };
}
