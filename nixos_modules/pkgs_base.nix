{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  module = "_pkgs_base";
  description = "pkgs needed by all systems";
  inherit (lib) mkEnableOption mkIf;
in {
  # imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    environment.defaultPackages = lib.mkForce [];

    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      inputs.zig_overlay.packages.x86_64-linux.master # needed by compiler_exlorer image

      ### Search ###
      fd # # Search file names
      fzy # # fzf but better
      ripgrep # # Fastest Sercher
      yt-dlp # # youtube downloader
      # ripgrep-all # # Better rg #BUG: there is a bug in source code

      ### Tools ###
      wezterm
      git
      bat
      jq # # CLI JSON processor
      dig # Networking tools
      bottom
      unzip
      nmap
      wget
      nushell
    ];
  };
}
