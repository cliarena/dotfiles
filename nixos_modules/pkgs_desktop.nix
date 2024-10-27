{ config, lib, pkgs, ... }:
let
  module = "_pkgs_desktop";
  description = "pkgs needed by desktop";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

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

      bemenu
      moonlight-qt

      ### Tools ###
      file # shows types of files needed by yazi
      poppler # PDF rendering lib needed by yazi
      xclip # cli clipboard utility needed by yazi
      wl-clipboard # cli wayland clipboard utility needed by yazi
      wlr-randr
      wayland-utils
      s-tui
      sysbench
      speedtest-cli

      pavucontrol
      pulseaudio
      obs-studio
      blender
      taskwarrior-tui
      timewarrior
      python3 # needed by taskwarrior & timewarrior

    ];
  };
}
