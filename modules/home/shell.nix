{ ... }: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false,
        edit_mode: vi,
      }
    '';
    envFile.text = ''
      def create_left_prompt [] {
      starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
      }
      load-env {
      STARSHIP_SHELL : "nu",
      # Use nushell functions to define your right and left prompt
      PROMPT_COMMAND : { || create_left_prompt },
      PROMPT_COMMAND_RIGHT : "",
      # The prompt indicators are environmental variables that represent
      # the state of the prompt
      PROMPT_INDICATOR : "",
      PROMPT_INDICATOR_VI_INSERT : ": ",
      PROMPT_INDICATOR_VI_NORMAL : "  ",
      PROMPT_MULTILINE_INDICATOR : "::: ",
      }
    '';
    shellAliases = {
      l = "ls";
      ll = "ls -l";
      la = "ls -a";
    };
  };
  programs.starship.enable = true;
}
