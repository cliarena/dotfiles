{ pkgs, sops-nix, hyprland, ... }: {

  home = {
    stateVersion = "22.11";
    username = "x";
    homeDirectory = "/home/x";
  };

  imports = [
    # sops-nix.homeManagerModules.sops
    # ./sops.nix
    ../../modules/home/ssh.nix
    # ../../modules/home/git.nix
  ];
  programs.home-manager.enable = true;
  # programs.neovim = import ../../modules/nvim pkgs;
}
