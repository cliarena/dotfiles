{ config, lib, inputs,pkgs, ... }:
let
  module = "hyodo";
  description = "hyodo space";
  inherit (lib) mkEnableOption mkIf;

  host =  {
    user = "hyodo";
    ssh_authorized_keys = [];
  };

  ENV_VARS = {
    WAYLAND_DISPLAY = "wayland-3";
    WOLF_RENDER_NODE = "/dev/dri/renderD128";
    XDG_RUNTIME_DIR = "/tmp/sockets";
  };
in {

  options.spaces.${module}.enable = mkEnableOption description;

  config = mkIf config.spaces.${module}.enable {

    containers."space-${module}" = {

      bindMounts = {
        "/tmp" = {
          hostPath = "/tmp";
          isReadOnly = false;
        };
        "${ENV_VARS.WOLF_RENDER_NODE}" = {
          hostPath = "${ENV_VARS.WOLF_RENDER_NODE}";
          isReadOnly = false;
        };
        "/home/${host.user}/space" = {
          hostPath = "/srv/spaces";
          isReadOnly = false;
        };
      };

      allowedDevices = [
        {
          modifier = "rw";
          node = "/dev/dri/card0";
        }
        {
          modifier = "rw";
          node = "/dev/dri/renderD128";
        }
      ];

      specialArgs = { inherit inputs host pkgs; };
      restartIfChanged = false;
      autoStart = true;
      ephemeral = true;

      config = { ... }: {

        environment.sessionVariables = ENV_VARS;
        environment.variables = ENV_VARS;

        services.getty.autologinUser = host.user;

        imports = lib.fileset.toList ../profiles;

        profiles.common.enable = true;
        profiles.desktop.enable = true;

        _sshd.enable = true;
        _taskwarrior.enable = true;

        _gaming.enable = true;
        _ankama.enable = true;
      };
    };
  };
}
