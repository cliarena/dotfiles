{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    extraPlugins = with pkgs.vimPlugins;
      [
        catppuccin-nvim # # Theme
      ];
    options = import ./options.nix { };
    colorscheme = "catppuccin";
    plugins.comment-nvim.enable = true;
    plugins.lualine = import ./lualine.nix { };
  };
}
