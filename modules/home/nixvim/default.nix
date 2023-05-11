{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    extraPlugins = with pkgs.vimPlugins;
      [
        catppuccin-nvim # # Theme
      ];
    colorscheme = "catppuccin";
    plugins.lualine = import ./lualine.nix { };
  };
}
