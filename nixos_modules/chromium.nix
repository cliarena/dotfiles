{ config, lib, ... }:
let
  module = "_chromium";
  deskription = "chromium oss";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {
    programs.chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
      };
      extensions = [
        "dnebklifojaaecmheejjopgjdljebpeo" # Everhour time tracker
        "mbnbehikldjhnfehhnaidhjhoofhpehk" # Css pepper
        # "eljapbgkmlngdpckoiiibecpemleclhh" # Fonts ninja -- auto opens new tabs
        "pekhihjiehdafocefoimckjpbkegknoh" # Site pallet
        "baocaagndhipibgklemoalmkljaimfdj" # Dimensions
        "epejoicbhllgiimigokgjdoijnpaphdp" # Emmet Re:view
        "inmopeiepgfljkpkidclfgbgbmfcennb" # Responsive viewer
        # "ckejmhbmlajgoklhgbapkiccekfoccmk" # Mobile simulator -- auto opens new tabs
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock origin
      ];
    };

  };
}
