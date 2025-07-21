{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_tokens_graph";
  description = "tokens studio graph tool for fluid tokens";
  inherit (lib) mkEnableOption mkIf;

  tokens_graph = pkgs.stdenv.mkDerivation rec {
    pname = "tokens_graph";
    version = "4.6.0";
    src = pkgs.fetchFromGitHub {
      owner = "tokens-studio";
      repo = "graph-engine";
      rev = "d651ccc3ceb1e5600c564f7783d534e100a26aa5";
      hash = "sha256-xSJ8ff+np7Nnd21voESMHmyTa3yNYazSaVoRgZ1fXBM=";
    };
    # inherit version src;

    yarnOfflineCache = pkgs.fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-H88dGQolTo70Q5Qvck77TR2GPGnKHl4PICyVwvLn4AQ=";
    };

    nativeBuildInputs = with pkgs; [
      yarnConfigHook
      yarnBuildHook
      nodejs
      turbo
    ];

    # dontNpmPrune = true;
    doCheck = false;
    yarnBuildScript = "build:engine";
    postInstall = ''
      mkdir -p $out/dist
      cp -r dist/** $out/dist
    '';
  };
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = [tokens_graph];
    #   services.pulseaudio = {
    #     # Needed by wolf to get audio
    #     enable = true;
    #     systemWide = true;
    #   };
  };
}
