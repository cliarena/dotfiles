{ ... }:
let
     pkgs = import (builtins.fetchGit {
         # Descriptive name to make the store path easier to identify
         name = "envoy-1.26.4";
         url = "https://github.com/NixOS/nixpkgs/";
         ref = "refs/heads/nixpkgs-unstable";
         rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0d";
     }) {};
in
{
  services.envoy = {
    package = pkgs.envoy;
    enable = true;
  };
}
