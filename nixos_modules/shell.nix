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
              shell_integration: true,
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

            # Todos
            t = "taskwarrior-tui";
          };
        };
        starship.enable = true;
      };
    };
  };
}
