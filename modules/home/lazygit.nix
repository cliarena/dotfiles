{
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [{
        key = "c";
        command = "git cz c";
        description = "commit with commitizen";
        context = "files";
        loadingText = "opening commitizen commit tool";
        subprocess = true;
      }];
      gui = {
        sidePanelWidth = 0.3; # number from 0 to 1
        showIcons = true;
        splitDiff = "always";
        theme = {
          showIcons = true;
          lightTheme = false;
          activeBorderColor = [
            "#a6e3a1" # Green
            "bold"
          ];
          inactiveBorderColor = [
            "#cdd6f4" # Text
          ];
          optionsTextColor = [
            "#89b4fa" # Blue
          ];
          selectedLineBgColor = [
            "#313244" # Surface0
          ];
          selectedRangeBgColor = [ # diff lines BG colors
            # "#313244" # Surface0
            "default"
          ];
          cherryPickedCommitBgColor = [
            "#94e2d5" # Teal
          ];
          cherryPickedCommitFgColor = [
            "#89b4fa" # Blue
          ];
          unstagedChangesColor = [
            "red" # Red
          ];
        };
      };
    };
  };
}
