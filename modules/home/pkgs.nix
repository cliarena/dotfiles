{ pkgs, ... }: {

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  home.packages = with pkgs; [
    manix # # CLI Searcher for Nix, HM documentation
    jq # # CLI JSON processor
    jqp # # jq playground
    htmlq # # jq fo html
    fd # # Search file names
    ripgrep # # Fastest Sercher
    ripgrep-all # # Better rg
    wget
    ventoy-bin # multiple Bootable usb drives in one
  ];
}
