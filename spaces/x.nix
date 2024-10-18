{ config, lib, inputs, ... }:
let
  module = "x";
  description = "x space";
  inherit (lib) mkEnableOption mkIf;

  host = rec {
    user = "x";
    hostAddress = "10.10.2.1";
    localAddress = "10.10.2.100";
    wan_ips = [ "${localAddress}/24" ];
    wan_gateway = [ hostAddress ];
    is_dns_server = false; # for testing hashi_stack
    dns_server = wan_gateway;
    dns_extra_hosts = "";
    ssh_authorized_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDODhAGCpRb2xFiBi9tMOtegTWaze+gmYtQkaUWRqF/u dev_space"
    ];
    ports = {
      dns = 53;
      ssh = 22;
    };
    # open the least amount possible
    tcp_ports = with ports; [ dns ssh 8080 ];
    udp_ports = with ports; [ dns ];
  };

  ENV_VARS = {
    WAYLAND_DISPLAY = "wayland-3";
    WOLF_RENDER_NODE = "/dev/dri/renderD128";
    XDG_RUNTIME_DIR = "/tmp/sockets";
  };
in {

  options.spaces.${module}.enable = mkEnableOption description;

  config = mkIf config.spaces.${module}.enable {

    containers.space-x = {

      bindMounts = {
        "/tmp" = {
          hostPath = "/tmp";
          isReadOnly = false;
        };
        "${ENV_VARS.WOLF_RENDER_NODE}" = {
          hostPath = "${ENV_VARS.WOLF_RENDER_NODE}";
          isReadOnly = false;
        };
        "/srv" = { # needed for sops
          hostPath = "/srv";
          isReadOnly = false;
        };
        "/var/lib/acme" = { # needed for terraform certs consul_config_entry
          hostPath = "/var/lib/acme";
          isReadOnly = true;
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

      specialArgs = { inherit inputs host; };
      interfaces = [ "mv-qub0" ];
      restartIfChanged = false;
      autoStart = true;
      ephemeral = true;

      config = { ... }: {

        environment.sessionVariables = ENV_VARS;
        environment.variables = ENV_VARS;

        services.getty.autologinUser = "x";

        imports = [
          ../modules/hardware/amd.nix
          ../modules/netwoking/container-network.nix
          ../modules/boot/amd.nix
        ] ++ lib.fileset.toList ../profiles;

        profiles.common.enable = true;
        profiles.desktop.enable = true;

        _sshd.enable = true;
        _taskwarrior.enable = true;
      };
    };
  };
}
