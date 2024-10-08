{ config, lib, pkgs, ... }:
let
  module = "_pkgs_desktop";
  deskription = "pkgs needed by desktop";
  inherit (lib) mkEnableOption mkIf;
in {


  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    environment.systemPackages = with pkgs; [

    ### Git ###
    gh
    commitizen

    ### Web ###
    w3m
    mpv
    youtube-tui

    jqp # # jq playground
    htmlq # # jq fo html
    httpie
    pgcli
    manix # # CLI Searcher for Nix, HM documentation

    brave
    chromium

    kitty

    ### Tools ###
    file # shows types of files needed by yazi
    poppler # PDF rendering lib needed by yazi
    xclip # cli clipboard utility needed by yazi
    wl-clipboard # cli wayland clipboard utility needed by yazi
    s-tui
    sysbench
    speedtest-cli

    pavucontrol
    obs-studio
    blender
    taskwarrior-tui
    timewarrior
    python3 # needed by taskwarrior & timewarrior

    ];
  };
}
