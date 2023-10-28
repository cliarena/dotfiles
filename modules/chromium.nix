{ ... }: {
  programs.chromium = {
    enable = true;
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
    };
    extensions = [
      "mbnbehikldjhnfehhnaidhjhoofhpehk" # Css pepper
      "eljapbgkmlngdpckoiiibecpemleclhh" # Fonts ninja
      "pekhihjiehdafocefoimckjpbkegknoh" # Site pallet
      "baocaagndhipibgklemoalmkljaimfdj" # Dimensions
      "epejoicbhllgiimigokgjdoijnpaphdp" # Emmet Re:view
      "inmopeiepgfljkpkidclfgbgbmfcennb" # Responsive viewer
      "ckejmhbmlajgoklhgbapkiccekfoccmk" # Mobile simulator
      ];
  };
}
