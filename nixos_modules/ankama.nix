{ config, lib, pkgs, ... }:
let
  module = "_ankama";
  description = "ankama launcher";
  inherit (lib) mkEnableOption mkIf;

  name = "ankama-launcher";
  src = builtins.fetchurl {
    # url = "https://download.ankama.com/launcher/full/linux/x64";
    url =
      "https://launcher.cdn.ankama.com/installers/production/Ankama+Launcher-Setup-x86_64.AppImage";
    sha256 =
      "00mag1kjvqcxhs50fwvjyw5wvrkn8lagbr1lzkqg8rgac1qzb6p3"; # Change for the sha256 you get after running nix-prefetch-url https://download.ankama.com/launcher/full/linux/x64
    name = "ankama-launcher.AppImage";
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
