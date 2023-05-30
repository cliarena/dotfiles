{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ### Git ###
    gh
    git
    commitizen

    ### Web ###
    w3m
    python310Packages.howdoi
    # mpv
    # ytfzf

    ### Programing ###
    wget
    dig # Networking tools
    jq # # CLI JSON processor
    jqp # # jq playground
    htmlq # # jq fo html
    httpie
    pgcli
    manix # # CLI Searcher for Nix, HM documentation
    kitty

    ### Search ###
    fd # # Search file names
    fzy # # fzf but better
    ripgrep # # Fastest Sercher
    ripgrep-all # # Better rg

    ### Session management ###
    zellij



    ### Session management ###
    dunst # # notification manager must for discord ...


    ### Tools ###
    bat
    unzip
    speedtest-cli
    nmap
    sops
    musikcube
    ventoy-bin # multiple Bootable usb drives in one
  ];

}
