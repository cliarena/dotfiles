{ lib, inputs, nixpkgs, ... }:
let

  inherit (inputs) sops-nix home-manager nixvim;
  host = rec {

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
  };

  ENV_VARS = {
    # inherit WAYLAND_DISPLAY WOLF_RENDER_NODE PULSE_SOURCE PULSE_SINK PULSE_SERVER; #XDG_RUNTIME_DIR;
    # inherit WAYLAND_DISPLAY WOLF_RENDER_NODE ;
    WAYLAND_DISPLAY = "wayland-3";
    WOLF_RENDER_NODE = "/dev/dri/renderD128";
    XDG_RUNTIME_DIR = "/tmp/sockets";

    #WAYLAND_DEBUG="server";
  };
in {

  containers.desktop = {

    specialArgs = { inherit inputs nixpkgs home-manager host; };
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
    autoStart = true;
    # privateNetwork = true;
    # hostAddress = "10.10.0.10";
    # localAddress = "10.10.0.100";
    # ephemeral = true;
    config = { config, pkgs, ... }: {

      environment.sessionVariables = ENV_VARS;
      environment.variables = ENV_VARS;
      environment.systemPackages = with pkgs; [
        kitty
        brave
        firefox
        wayland-utils
        wlr-randr
        swww # Wallpaper Daemon
      ];
      # hardware = {
      # opengl = {
      # enable = true;
      # driSupport32Bit = true;
      # extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
      # };
      # };

      services.getty.autologinUser = "x";
      programs.river.enable = true;

      imports = [
        # ../modules/netwoking/container-network.nix
        # ../modules/boot/amd.nix
        # ../modules/hardware/amd.nix
        ../modules/pipewire.nix

        home-manager.nixosModules.home-manager
        {
          inherit nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${host.user} = {
            imports = [
              sops-nix.homeManagerModules.sops
              ../hosts/x/sops.nix
              ../modules/home/river.nix
              ../modules/home/shell.nix
              ../modules/home/ssh.nix
              ../modules/home/git.nix
              ../modules/home/lazygit.nix
              ../modules/home/kitty.nix
              ../modules/home/direnv.nix
              ../modules/home/bottom.nix
              ../modules/home/eww
            ];
            home = {
              stateVersion = "22.11";
              username = "x";
              homeDirectory = "/home/${host.user}";
            };
          };
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit inputs nixpkgs home-manager;
          };
        }
      ] ++ lib.fileset.toList ../profiles;

      profiles.common.enable = true;
      profiles.desktop.enable = true;
    };
  };
}
