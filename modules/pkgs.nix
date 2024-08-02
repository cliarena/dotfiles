{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ### Git ###
    gh
    git
    commitizen

    ### Web ###
    w3m
    # python310Packages.howdoi
    brave
    mpv
    youtube-tui
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
    # ripgrep-all # # Better rg #BUG: there is a bug in source code
    chromium

    ### Session management ###
    zellij

    ### Session management ###
    dunst # # notification manager must for discord ...

    ### Tools ###
    bat
    file # shows types of files needed by yazi
    poppler # PDF rendering lib needed by yazi
    xclip # cli clipboard utility needed by yazi
    wl-clipboard # cli wayland clipboard utility needed by yazi
    # nu_scripts
    # glow
    bottom
    s-tui
    sysbench
    unzip
    speedtest-cli
    nmap
    sops
    # musikcube
    # ventoy-bin # multiple Bootable usb drives in one
    pavucontrol
    remmina
    blender
    taskwarrior-tui
    timewarrior
    # nodejs-slim # needed by trackwarrior
    python3 # needed by taskwarrior & timewarrior

    # appimage-run
    # bottles
    # wineWowPackages.waylandFull

    ### Virtualization ###
    virtiofsd # needed by microvm jobs to use virtiofs shares
  ];

}
