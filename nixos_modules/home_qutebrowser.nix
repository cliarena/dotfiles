{
  config,
  lib,
  pkgs,
  inputs,
  host,
  ...
}:
let
  module = "_home_qutebrowser";
  description = "qutebrowser config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in
{
  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    home-manager.users.${host.user} = {
      programs.qutebrowser = {
        enable = true;

        content = {
          pdfjs = true;
          autoplay = false;
        };
        searchEngines = {
          rsci = "https://sci-hub.st/match/{}";
          rarx = "https://arxiv.org/search/?query={}&searchtype=all&source=header";
          rana = "https://annas-archive.li/search?index=journals&q={}";
          rdoi = "https://annas-archive.li/scidb/{}";

          yt = "https://www.youtube.com/results?search_query={}";

          dict = "https://www.thesaurus.com/browse/{}";
          abbr = "https://www.abbreviations.com/abbreviation/{}";

          w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";

          mdn = "https://developer.mozilla.org/en-US/search?q={}";

          nw = "https://wiki.nixos.org/index.php?search={}";
          no = "https://search.nixos.org/options?channel=unstable&query={}";
          np = "https://search.nixos.org/packages?channel=unstable&query={}";
          nh = "https://home-manager-options.extranix.com/?query={}&release=master";
        };

        quickmarks = {
          focumon = "https://www.focumon.com/";

          zig_ref = "https://ziglang.org/documentation/master/";
          zig_std = "https://ziglang.org/documentation/master/std/";
        };

      };
    };
  };
}
