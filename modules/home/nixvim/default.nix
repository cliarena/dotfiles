{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    extraPackages = with pkgs; [ ];
    extraPlugins = with pkgs.vimPlugins; [
      alpha-nvim
      catppuccin-nvim # # Theme
      better-escape-nvim # escape with ii
    ];
    options = import ./options.nix { };
    colorscheme = "catppuccin";
    plugins.comment-nvim.enable = true;
    plugins.lualine = import ./lualine.nix { };
    plugins = {
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp-calc.enable = true;
      cmp-cmdline.enable = true;
      cmp-dap.enable = true;
      cmp-dictionary.enable = true;
      cmp-emoji.enable = true;
      # cmp-fuzzy-path.enable = true;
      # cmp-fuzzy-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-nvim-lua.enable = true;
      # cmp-tmux.enable = true;
      cmp_luasnip.enable = true;
    };
    plugins.conjure.enable = true;
    extraConfigLua = import ./config_lua { };
  };
}
