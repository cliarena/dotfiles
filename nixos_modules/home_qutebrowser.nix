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

        # TIP: Customize hinting per website
        # with config.pattern("https://frame.work/*"):
        # c.hints.selectors["all"].append("label[data-test-id=profile-icon]")
        settings = {
          content = {
            pdfjs = true;
            autoplay = false;
            prefers_reduced_motion = true;

          };
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
          nt = "https://nixpk.gs/pr-tracker.html?pr={}"; # Nixpkgs PR Tracker
        };

        quickmarks = {
          focumon = "https://www.focumon.com/";
          imh = "https://muhaffidh.app/";

          # Books
          balgo = "https://en.algorithmica.org/hpc/"; # Simd, Algorithm And Data_structure Book
          bods = "https://opendatastructures.org/ods-cpp/Contents.html";

          # Landscapes Viewers
          ldbs = "https://dbdb.io/browse";

          zigref = "https://ziglang.org/documentation/master/";
          zigstd = "https://ziglang.org/documentation/master/std/";
        };

      };
    };
  };
}
