{ pkgs, ... }: {
  services.kmscon = {
    enable = true;
    fonts = [{
      name = "JetBrainsMono nerd font";
      package = pkgs.nerdfonts;
    }];
  };
}
