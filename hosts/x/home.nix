{ ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [ ../../modules/home/ssh.nix ];
  programs.home-manager.enable = true;
}
