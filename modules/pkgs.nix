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
    jq # # CLI JSON processor
    jqp # # jq playground
    htmlq # # jq fo html
    httpie
    pgcli
    manix # # CLI Searcher for Nix, HM documentation

    ### Search ###
    fd # # Search file names
    fzy # # fzf but better
    ripgrep # # Fastest Sercher
    ripgrep-all # # Better rg

    ### Tools ###
    bat
    unzip
    speedtest-cli
    nmap
    musikcube
    ventoy-bin # multiple Bootable usb drives in one
  ];

}
