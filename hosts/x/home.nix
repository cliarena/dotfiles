{ pkgs, sops-nix, hyprland, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [
    sops-nix.homeManagerModules.sops
    ./sops.nix
    hyprland.homeManagerModules.default
    ../../modules/home/hyprland
    ../../modules/home/ssh.nix
    ../../modules/home/git.nix
    ../../modules/home/lazygit.nix
    ../../modules/home/shell.nix
    ../../modules/home/pkgs.nix
    ../../modules/home/bottom.nix
  ];
  programs.home-manager.enable = true;
  programs.neovim = import ../../modules/nvim pkgs;
}
