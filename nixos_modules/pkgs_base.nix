{ config, lib, pkgs, ... }:
let
  module = "_pkgs_base";
  description = "pkgs needed by all systems";
  inherit (lib) mkEnableOption mkIf;
in {

  # imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    environment.systemPackages = with pkgs; [

      ### Search ###
      fd # # Search file names
      fzy # # fzf but better
      ripgrep # # Fastest Sercher
      # ripgrep-all # # Better rg #BUG: there is a bug in source code

      ### Tools ###
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
