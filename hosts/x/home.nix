{ pkgs, sops-nix, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [
    sops-nix.homeManagerModules.sops
    ./sops.nix
    ../../modules/home/lazygit.nix
    ../../modules/home/shell.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/bottom.nix
  ];
  programs.home-manager.enable = true;
  programs.neovim = import ../../modules/nvim pkgs;
}
