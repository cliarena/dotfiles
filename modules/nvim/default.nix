pkgs: {
  enable = true;
  # package = pkgs.neovim-nightly;

  viAlias = true;
  defaultEditor = true;
  withNodeJs = false;
  withRuby = false;
  withPython3 = false;

  extraLuaConfig = builtins.foldl' (x: y: builtins.readFile y + x) "" [
    ./options.lua
    ./autopairs.lua
    ./auto-save.lua
    ./comment.lua
    ./nvim-tree.lua
    ./toggleterm.lua
    ./project.lua
    ./guess-indent.lua
    ./theme.lua
    ./dashboard.lua
    # it should be disabled so showtabline=0 works
    # ./bufferline.lua
    ./lualine.lua
    ./keymaps.lua
    ./which-key.lua
    ./true-zen.lua
    ./twilight.lua
    ./todo-comments.lua
    ./trouble.lua
    ./telescope.lua
    ./highlight-colors.lua
    ./inc-rename.lua
    ./noice.lua
    ./vim-illuminate.lua
    ./diagnostics.lua
    ./cmp.lua
    ./treesitter.lua
    ./lsp.lua
    ./lsp_signs.lua
    ./lsp_signature.lua
    ./null-ls.lua
    #./lsp_lines.lua
    ./aerial.lua
    ./leap.lua
    ./flit.lua
    ./neorg.lua
    ./gitsigns.lua
    ./lastplace.lua
    ./better-escape.lua
    ./template-string.lua
    ./surround.lua
    #    ./rename-state.lua
    ./urlview.lua
    #  ./hologram.lua
    # ./lspsaga.lua
    #./glow.lua
  ];
  plugins = with pkgs.vimPlugins; [
    popup-nvim # # Needed by some plugins
    plenary-nvim # # Lua Library
    nvim-tree-lua # # File Explorer
    bufdelete-nvim # # Close Buffer without messing Splits layout
    toggleterm-nvim # # Toggle multiple Terminals
    project-nvim # # Superior Project Management
    guess-indent-nvim # # Auto-detect indentation style
    editorconfig-nvim # # EditorConfig support. No longer needed in neovim v0.9. its builtin
    direnv-vim # # Direnv integration

    ## UI
    onedark-nvim # # Theme
    catppuccin-nvim # # Theme
    alpha-nvim # # Dashboard in lua
    nvim-web-devicons # # Icons
    # bufferline-nvim # # Tabs Functionality
    lualine-nvim # # Fancier Statusline
    indent-blankline-nvim # # add indentation guides even on blank lines
    true-zen-nvim # # Distraction Free Coding
    twilight-nvim # # Dimm innactive code

    ## animation-nvim        ## Library to create animations
    windows-nvim # # Auto expand focused window
    todo-comments-nvim # # manage Todo comments
    nvim-highlight-colors # # Highlight colors
    nui-nvim # # UI Component Library
    nvim-notify # # Fancy, configurable notification manager
    noice-nvim # # Better inputs
    vim-illuminate # # Highlight words similar to on-cursor
    which-key-nvim # # Show Keybindings in popup

    ## Auto-Completion 
    nvim-cmp # # Completion Engine
    cmp-buffer # # Buffer Completion
    cmp-path # # Path Completion
    cmp-cmdline # # Cmdline Completion
    cmp-nvim-lsp # # built-in language server client Source
    cmp-nvim-lua # # neovim Lua api Source
    cmp_luasnip # # Luasnip Source
    SchemaStore-nvim # # Largest Json Schemas source
    nvim-autopairs # # Auto close braces
    comment-nvim # # Easy Commenting

    ## Snippets
    luasnip # # Snippets engine
    friendly-snippets # # Snippets Collection

    ## LSP
    nvim-lspconfig # # Configs for LSP
    null-ls-nvim # # Formatting, Diagnostics, Code Action...
    lsp_signature-nvim # # Show Function Signature
    # lsp_lines-nvim # # Show Diagnostics using virtual line
    lspsaga-nvim # LSP++

    ## Telescope
    telescope-nvim # # Highly extandable Fuzzy Finder
    telescope-fzf-native-nvim # # Native FZF sorter
    telescope-manix # # Search Nix, HM documentation
    telescope-media-files-nvim # # View images in preview
    # telescope-luasnip-nvim            ## Search luasnipets TODO:add to nixpkgs
    # tailiscope-nvim       ## Tailwindcss Cheat Sheet TODO:add to nixpkgs

    ## TreeSitter
    nvim-treesitter # # TreeSitter Configurations and abstrations
    nvim-treesitter.withAllGrammars # # All treesitter parsers
    nvim-ts-rainbow # # Rainbow Parentheses
    nvim-ts-context-commentstring # # Comment style based on context
    nvim-ts-autotag # # auto-close tag
    aerial-nvim # # symbol tree panel
    leap-nvim # # Leap Through code
    flit-nvim # # f/F/t/T motions on steroids
    # leap-spooky         ## Remote operations without leaving. eg: yank paragraph in another window TODO: add to nixpkgs

    ## DAP
    trouble-nvim # # Show Diagnostics in a window

    ## Note Taking
    ## mind-nvim
    ## Venn-nvim
    neorg # # Org mode for neovim
    glow-nvim # # Preview Markdown in Neovim
    markdown-preview-nvim # # Preview Markdown in browser support diagrams

    ## GIT
    lazygit-nvim # # TUI for GIT
    gitsigns-nvim # # Git superpower in Buffers
    diffview-nvim # # Tabpage to view all diffs in splits

    ## Session Management
    nvim-lastplace # # Reopen files at last edited place
    Navigator-nvim # # Easy Navigate between neovim and tmux
    # harpoon # Faster buffer navigation
    # auto-session   ## Session manager 
    # session-lens-nvim     ## Integrate Session manager with Telescope ## TODO: add to nix 

    ## Utilities
    better-escape-nvim # # Escape input eg:"ii" with no delay
    text-case-nvim # # Text Case Smart Converter
    template-string-nvim # # Smart Sting Quotation
    surround-nvim # # Surround with brackets, quotes...
    # nvim-rename-state # # Rename Setter & Getter of React State Hook
    vim-repeat # # . to repeat command Functionality
    inc-rename-nvim # # Live view LSP renaming
    live-command-nvim # # Live Preview Commands effects
    auto-save-nvim # # Auto save
    ## wilder-nvim
    hydra-nvim # # Easier Sequential commands
    urlview-nvim # # Find & Display urls
    hologram-nvim # # Preview images
    ## grammar-guard-nvim    ## fix misspells. unmaintened
    dial-nvim # # Easy edit dates, versions...
    ## fm-nvim            ## Use Terminal file manager in neovim TODO: add to nixpkgs

    ## Rust tools
    crates-nvim # # Manage Crates.io dependencies

    ## Optimizations
    impatient-nvim # # Speed up loading Lua modules
  ];
  extraPackages = with pkgs; [ zig cargo rust-analyzer rustfmt nil nixfmt ];

}
