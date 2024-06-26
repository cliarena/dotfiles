{ inputs, nixpkgs, ... }:
let

  user = "x";
  wan_ips = [ "10.10.0.100/24" ];
  wan_gateway = [ "10.10.0.10" ];
  is_dns_server = false; # for testing hashi_stack
  dns_server = wan_gateway;
  dns_extra_hosts = "";
  ports = {

    dns = 53;
    ssh = 22;
  };
  # open the least amount possible
  tcp_ports = with ports; [ dns ssh 8080 ];
  udp_ports = with ports; [ dns ];

  ENV_VARS = {
        # inherit WAYLAND_DISPLAY WOLF_RENDER_NODE PULSE_SOURCE PULSE_SINK PULSE_SERVER; #XDG_RUNTIME_DIR;
        /* inherit WAYLAND_DISPLAY WOLF_RENDER_NODE ; */
        WAYLAND_DISPLAY = "wayland-3";
        WOLF_RENDER_NODE = "/dev/dri/renderD128";
        XDG_RUNTIME_DIR = "/tmp/sockets";
        
        #WAYLAND_DEBUG="server";
      };
in {

  containers.desktop = {

   bindMounts = {
    "/tmp" = {
       hostPath = "/tmp";
       isReadOnly = false;
    };
     "${ENV_VARS.WOLF_RENDER_NODE}" = {
        hostPath = "${ENV_VARS.WOLF_RENDER_NODE}";
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
    autoStart = true;
    # privateNetwork = true;
    # hostAddress = "10.10.0.10";
    # localAddress = "10.10.0.100";
    # ephemeral = true;
    config = { config, pkgs, ... }: {

     environment.sessionVariables = ENV_VARS;
     environment.variables = ENV_VARS;
     environment.systemPackages = with pkgs; [ kitty brave firefox wayland-utils weston  sway hyprland];
     hardware = {
        opengl = {
          enable = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
        };
      };

     programs.hyprland.enable = true;
     nix.extraOptions = ''
       experimental-features = nix-command flakes
       keep-outputs = true
       keep-derivations = true
       warn-dirty = false
     '';

    services.getty.autologinUser = "x";
        users.users.x = {
          isNormalUser = true;
          initialPassword = "nixos";
          extraGroups = [
            # "avahi" # needed to read /var/lib/acme files for terranix apply
            "wheel"
            "input"
            "video"
            "sound"
          ];
         # shell = pkgs.nushell;
        };
    };
  };
}
