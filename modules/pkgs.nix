{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ### Git ###
    gh
    commitizen

    ### Web ###
    w3m
    # python310Packages.howdoi
    brave
    mpv
    youtube-tui
    # ytfzf

    jqp # # jq playground
    htmlq # # jq fo html
    httpie
    pgcli
    manix # # CLI Searcher for Nix, HM documentation
    kitty

    chromium

    ### Session management ###
    zellij

    ### Session management ###
    dunst # # notification manager must for discord ...

    ### Tools ###
    file # shows types of files needed by yazi
    poppler # PDF rendering lib needed by yazi
    xclip # cli clipboard utility needed by yazi
    wl-clipboard # cli wayland clipboard utility needed by yazi
    # nu_scripts
    # glow
    s-tui
    sysbench
    speedtest-cli
    sops
    # musikcube
    # ventoy-bin # multiple Bootable usb drives in one
    pavucontrol
    remmina
    obs-studio
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
