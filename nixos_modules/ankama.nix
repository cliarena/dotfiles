{ config, lib, pkgs, ... }:
let
  module = "_ankama";
  description = "ankama launcher";
  inherit (lib) mkEnableOption mkIf;

  name = "ankama-launcher";
  src = builtins.fetchurl {
    name = "ankama-launcher.AppImage";

    # Old
    url =
      "https://launcher.cdn.ankama.com/installers/production/Ankama+Launcher-Setup-x86_64.AppImage";
    sha256 = "00mag1kjvqcxhs50fwvjyw5wvrkn8lagbr1lzkqg8rgac1qzb6p3";

    # To get sha256: nix-prefetch-url <url>
    # url = "https://launcher.cdn.ankama.com/installers/production/Dofus_3.0-x86_64.AppImage";
    # sha256 = "16vyw20sq632nshm4fj11mv7qx6k6nwbjk9hbkcmiq1m45i1r766";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    environment.systemPackages = with pkgs;
      [
        (appimageTools.wrapType2 {
          inherit name src;

          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/zaap.desktop $out/share/applications/ankama-launcher.desktop
            sed -i 's/.*Exec.*/Exec=ankama-launcher/' $out/share/applications/ankama-launcher.desktop
            install -m 444 -D ${appimageContents}/zaap.png $out/share/icons/hicolor/256x256/apps/zaap.png
          '';
        })

      ];
  };
}
