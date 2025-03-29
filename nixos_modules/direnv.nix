{ config, lib, host, ... }:
let
  module = "_direnv";
  description = "auto load environments";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = { config, ... }:
      let inherit (config.home) homeDirectory;
      in {
        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
            config = {
              whitelist.prefix = [
                "${homeDirectory}/dotfiles"
                "${homeDirectory}/project_main"
                "${homeDirectory}/project_seconday"
              ];
            };
            stdlib = ''
              : "''${XDG_CACHE_HOME:="/srv/.cache"}"
              declare -A direnv_layout_dirs
              direnv_layout_dir() {
                  local hash path
                  echo "''${direnv_layout_dirs[$PWD]:=$(
                      hash="$(sha1sum - <<< "$PWD" | head -c40)"
                      path="''${PWD//[^a-zA-Z0-9]/-}"
                      echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
                  )}"
              };
            '';
          };
        };
      };
  };
}
