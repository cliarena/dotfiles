{ pkgs, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [ ];
  programs.home-manager.enable = true;
}
