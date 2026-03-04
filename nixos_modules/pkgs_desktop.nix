{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_pkgs_desktop";
  description = "pkgs needed by desktop";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = with pkgs; [
      ### Git ###
      #   gh
      #   commitizen

      ### Web ###
      w3m
      #  mpv
      #   youtube-tui

      kdePackages.kcachegrind
      binutils # needed by kcachegrind to show code output assembly & control flow..

      qrrs # QR code cli printer
      jqp # # jq playground
      htmlq # # jq fo html
      httpie
      #   pgcli
      manix # # CLI Searcher for Nix, HM documentation

      brave
      ungoogled-chromium
      qutebrowser

      # kitty

      #   bemenu
      #   moonlight-qt

      ### Design ###
      #   darktable
      inkscape-with-extensions
      gimp-with-plugins
      ansel # darktable minus bloat
      blender # use hip to get gpu acceleration

      # Guassian Splatting
      openmvg
      # openmvs
      # colmap
      (openmvs.overrideAttrs (
        finalAttrs: prevAttrs: {

          src = fetchFromGitHub {
            owner = "cdcseacave";
            repo = "openmvs";
            rev = "v2.4.0";
            hash = "sha256-0tL2tqHYBQMGL9k+NqTUxieWuDP3YB6X9DcXYnlGWWg=";
            fetchSubmodules = true;
          };
          buildInputs = prevAttrs.buildInputs ++ [
            libjxl
            nanoflann
          ];
          nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ python3Packages.python ];

          cmakeFlags = prevAttrs.cmakeFlags ++ [
            (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3Packages.python))
          ];

          checkPhase = ''
            runHook preCheck
            ${lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
              export KMP_AFFINITY=disabled
              export OMP_PROC_BIND=false
            ''}
            ctest --output-on-failure
            runHook postCheck
          '';
        }
      ))

      ### Tools ###
      file # shows types of files needed by yazi
      poppler # PDF rendering lib needed by yazi
      xclip # cli clipboard utility needed by yazi
      wl-clipboard # cli wayland clipboard utility needed by yazi
      # wlr-randr
      # wayland-utils
      #   s-tui
      #   sysbench
      # speedtest-cli
      grim

      # pavucontrol
      # pulseaudio
      #   obs-studio
      # taskwarrior-tui
      # timewarrior
      # python3 # needed by taskwarrior & timewarrior
    ];
  };
}
