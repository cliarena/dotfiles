{ pkgs, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [ ../../modules/home/lazygit.nix ../../modules/home/shell.nix ];
  programs.home-manager.enable = true;
}
