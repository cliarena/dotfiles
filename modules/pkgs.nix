{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    bat
    jq
    unzip
    speedtest-cli
    httpie
    nmap
    musikcube

    # mpv
    # ytfzf

    ### Search ###
    gh
    w3m
    python310Packages.howdoi

    # programing
    pgcli

  ];

}
