{ config, lib, inputs, host, ... }:
let
  module = "_shell";
  description = "shell config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = {
      programs = {
        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };
        atuin = {
          enable = true;
          enableNushellIntegration = true;
          settings = { };
        };
        yazi = {
          enable = true;
          enableNushellIntegration = true;
          settings = {
            log = { enabled = false; };
            manager = {
              show_hidden = false;
              # sort_by = "modified";
              sort_dir_first = true;
              # sort_reverse = true;
            };
          };
          # keymap = {
          # input.keymap = [
          # {
          # exec = "close";
          # on = [ "" ];
          # }
          # {
          # exec = "close --submit";
          # on = [ "" ];
          # }
          # {
          # exec = "escape";
          # on = [ "" ];
          # }
          # {
          # exec = "backspace";
          # on = [ "" ];
          # }
          # ];
          # manager.keymap = [
          # {
          # exec = "escape";
          # on = [ "" ];
          # }
          # {
          # exec = "quit";
          # on = [ "q" ];
          # }
          # {
          # exec = "close";
          # on = [ "" ];
          # }
          # ];
          # };
        };
        zoxide = {
          enable = true;
          enableNushellIntegration = true;
        };

        nushell = {
          enable = true;
          configFile.text = ''
            $env.config = {
              show_banner: false,
              edit_mode: vi,
              shell_integration: {
                # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
                osc2: true
                # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
                osc7: true
                # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it
                osc8: true
                # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
                osc9_9: false
                # osc133 is several escapes invented by Final Term which include the supported ones below.
                # 133;A - Mark prompt start
                # 133;B - Mark prompt end
                # 133;C - Mark pre-execution
                # 133;D;exit - Mark execution finished with exit code
                # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
                osc133: true
                # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
                # 633;A - Mark prompt start
                # 633;B - Mark prompt end
                # 633;C - Mark pre-execution
                # 633;D;exit - Mark execution finished with exit code
                # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
                # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
                # and also helps with the run recent menu in vscode
                osc633: true
                # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
                reset_application_mode: true
              }
            }
          '';
          envFile.text = ''
            def create_left_prompt [] {
            starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
            }
            load-env {
            STARSHIP_SHELL : "nu",
            MANPAGER : "nvim +Man!",
            MANWIDTH : 999,
            # Use nushell functions to define your right and left prompt
            PROMPT_COMMAND : { || create_left_prompt },
            PROMPT_COMMAND_RIGHT : "",
            # The prompt indicators are environmental variables that represent
            # the state of the prompt
            PROMPT_INDICATOR : "",
            PROMPT_INDICATOR_VI_INSERT : ": ",
            PROMPT_INDICATOR_VI_NORMAL : "  ",
            PROMPT_MULTILINE_INDICATOR : "::: ",
            EDITOR : "nvim"
            }
          '';
          shellAliases = {
            l = "ls";
            ll = "ls -l";
            la = "ls -a";
            y = "yazi";
            n = "nvim";
            da = "direnv allow";
            gc = "git clone";
            # download 1h of youtube as audio
            yt-1h-audio =
              "yt-dlp -x --audio-quality 0 --write-thumbnail --download-sections '*0-3600'";

            # Todos
            t = "taskwarrior-tui";
          };
        };
        starship.enable = true;
      };
    };
  };
}
