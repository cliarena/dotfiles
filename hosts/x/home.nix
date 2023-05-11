{ nixvim, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [
    nixvim.homeManagerModules.nixvim
    ../../modules/home/lazygit.nix
    ../../modules/home/shell.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/bottom.nix
    ../../modules/home/nixvim
  ];
  programs.home-manager.enable = true;
}
