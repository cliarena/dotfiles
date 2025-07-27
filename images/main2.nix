{
  lib,
  pkgs,
  inputs,
  ...
}: let
  menu = "${pkgs.bemenu}/bin/bemenu-run";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  mode = "Alt";
  resolution = "3840x2160";
  host = rec {
    user = "retro";
    wan_ips = ["10.10.2.222/24"];
    wan_gateway = ["10.10.2.1"];
    is_dns_server = false; # for testing hashi_stack
    dns_server = wan_gateway;
    dns_extra_hosts = "";
    ports = {
      dns = 53;
    };
    # open the least amount possible
    tcp_ports = with ports; [dns 8080];
    udp_ports = with ports; [dns];
  };
  compressCommand = "";
  compressionExtension = "";
in
  inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      inherit (inputs) nixpkgs home-manager;
      inherit host;
    };

    format = "docker";

    modules =
      [
        ../modules/boot/amd.nix
        ../modules/hardware/amd.nix

        {
          systemd.oomd.enable = false;

          _home_gitter.enable = true;

          _nix.enable = true;
          _users.enable = true;
          _local.enable = true;

          _home.enable = true;
          _home_wezterm.enable = true;
          # _home_qutebrowser.enable = true;
          _sops_home.enable = true;
          #_ssh_home.enable = true;

          # _shell.enable = true;
          _git.enable = true;
          _river.enable = true;

          #  environment.variables = {
          #    DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
          #    #    WOLF_CFG_FILE = "/srv/wolf/cfg/config.toml";
          #    #    WOLF_PRIVATE_KEY_FILE = "/srv/wolf/cfg/key.pem";
          #    WOLF_PRIVATE_CERT_FILE = "/srv/wolf/cfg/cert.pem";
          #    HOST_APPS_STATE_FOLDER = "/srv/wolf/state";
          #      XDG_RUNTIME_DIR = "/run/user/1000";
          #XXX = builtins.getEnv "SALAM";
          #     XDG_SESSION_TYPE = "wayland";
          #     WAYLAND_DISPLAY = "wayland-1";
          #     XDG_RUNTIME_DIR = "/tmp";
          #SWAYSOCK = "/tmp/sway.sock";
          #  };

          #  systemd.services."getty@tty1" = {
          #     overrideStrategy = "asDropin";
          #     serviceConfig = {
          #       PassEnvironment = "SALAM XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
          #       ExecStart =[ "" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin ${host.user} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
          #      };
          #     wantedBy = ["graphical.target" "greetd.service"];

          #   };

          #  services.displayManager = {
          #    enable = true;

          #    environment = {
          #           XDG_SESSION_TYPE = "wayland";
          #         WAYLAND_DISPLAY = "wayland-1";
          #          XDG_RUNTIME_DIR = "/tmp";
          #       };
          #    sddm = {
          #      enable =true;
          #      wayland.enable = true;
          #      package = pkgs.kdePackages.sddm;
          #    };
          #  };

          #  systemd.services."getty@tty1" = {
          #     overrideStrategy = "asDropin";
          #     serviceConfig = {
          #     PassEnvironment = "SALAM XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
          #      ExecStart =[ "" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin ${host.user} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
          #    };
          #     wantedBy = ["graphical.target"];
          #  after = ["desk.service"];
          #    after = ["multi-user.target"];

          #   };

          #   security.pam.services."getty@tty1" = {};

          #  security.pam.services.desk = {};

          systemd.services.permission-fixer = {
            script = ''
              #!${pkgs.stdenv.shell}
              set -euo pipefail


              chown ${host.user}:users /run/user/1000
              chmod u=rwx /run/user/1000
             '';

            serviceConfig.Type = "oneshot";
            wantedBy = ["multi-user.target"];
          };


          systemd.services.desk = {
            description = "desktop runner";
            path = with pkgs; [river];

            # environment = {
            #  DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/0/bus";
            #  PATH = lib.mkForce "/run/wrappers/bin:/root/.nix-profile/bin:/nix/profile/bin:/root/.local/state/nix/profile/bin:/etc/profiles/per-user//bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
            # };
            # preStart = "${pkgs.coreutils}/bin/env";
            script = "${pkgs.river}/bin/river";
            serviceConfig = {
              PassEnvironment = "SALAM XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
              AmbientCapabilities = "CAP_CHOWN CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_FOWNER CAP_SETGIDD CAP_SETFCAP CAP_SETUID CAP_SYS_ADMIN";
              User = host.user;
              # User= "root";
              # Group= "root";
              Restart = "on-failure";
              #   TimeoutSec = 3;
              # avoid error start request repeated too quickly since RestartSec defaults to 100ms
              RestartSec = 3;
            };
            after = ["multi-user.target" "permission-fixer.service" ];
            wantedBy = ["graphical.target"];
            #    after = ["getty@tty1.service"];
          };

          #   systemd.services.greetd = {
          # enable = false;
          #      description = "desktop runner";
          # path = with pkgs; [river];

          # environment = {
          #  DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/0/bus";
          #  PATH = lib.mkForce "/run/wrappers/bin:/root/.nix-profile/bin:/nix/profile/bin:/root/.local/state/nix/profile/bin:/etc/profiles/per-user//bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
          # };
          # preStart = "${pkgs.coreutils}/bin/env";
          # scriptArgs = "YOOOOOOOOO=SALAAAAAM";
          # preStart = "${pkgs.coreutils}/bin/ls /tmp /run/user/1000";
          #    preStart = "${pkgs.coreutils}/bin/mkdir -p /tmp/sockets &&  ${pkgs.coreutils}/bin/ln -s $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY /tmp/sockets/wayland-1";
          # preStart = "${pkgs.coreutils}/bin/ls /tmp /run/user/1000";
          #      postStop = "${pkgs.coreutils}/bin/ls /tmp /tmp/sockets";
          #      serviceConfig = {
          #        PassEnvironment = "SALAM XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
          #     User = host.user;
          #        Restart = "on-failure";
          #   TimeoutSec = 3;
          # avoid error start request repeated too quickly since RestartSec defaults to 100ms
          #        RestartSec = 3;
          #      };
          #  after = ["multi-user.target"];
          #  wantedBy = ["graphical.target" "greetd.service"];
          #  partOf = ["greetd.service"];
          #    };

          #    services.greetd = {
          #      enable = true;
          # vt = 4;
          #      settings = rec {
          #        initial_session = {
          # command = "XDG_RUNTIME_DIR=/tmp XDG_SESSION_DESKTOP=sway SWAYSOCK=/tmp/sway.sock XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.river}/bin/river";
          #          command = "${pkgs.execline}/bin/exec ${pkgs.systemd}/bin/systemd-cat --identifier=greeeetd  ${pkgs.river}/bin/river";
          #  command = ''${pkgs.execline}/bin/exec ${pkgs.systemd}/bin/systemd-cat --identifier=greeeetd ${pkgs.coreutils}/bin/env "$@"'';
          #          user = host.user;
          #        };
          #        default_session = initial_session;
          #      };
          #    };

          #             services.getty = {
          #               autologinUser = host.user;
          #             };
          #  environment.loginShellInit = ''
          #    XDG_RUNTIME_DIR=/tmp XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1    ${pkgs.river}/bin/river
          #  '';

          # [[ "$(tty)" == /dev/tty1 ]] && XDG_RUNTIME_DIR=/tmp XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.sway}/bin/sway

          users.users.retro = {
            uid = 1000;
            #  linger = true; #linger stops home manager services fromm starting on login
            isNormalUser = true;
            initialPassword = "nixos";
            extraGroups = [
              "wheel"
              "video"
              "sound"
              "input"
              "uinput"
            ];
          };

          # Rename network interface to wan
          services.udev.extraRules = ''
            KERNEL=="e*", NAME="wan"
          '';
          # Disable if this server is a dns server
          services.resolved.enable = false;

          networking = {
            hostName = host.user;
            extraHosts = "127.0.0.1 local.cliarena.com";
            useDHCP = false;
            useNetworkd = true;
            # nameservers = [ "1.1.1.1" ];
            resolvconf.enable = pkgs.lib.mkForce false;
            dhcpcd.extraConfig = "nohook resolv.conf";
            networkmanager.dns = "none";
            firewall = {
              enable = false;
              interfaces.wan = {
                allowedTCPPorts = host.tcp_ports;
                allowedUDPPorts = host.udp_ports;
              };
            };
          };
          systemd = {
            network = {
              enable = true;
              wait-online.anyInterface = true;
              networks = {
                "20-wired" = {
                  enable = true;
                  name = "wan";
                  address = host.wan_ips;
                  gateway = host.wan_gateway;
                  dns = host.dns_server;
                  # if you want dhcp uncomment this and comment address,gateway and dns
                  # DHCP = "ipv4";
                };
              };
            };
          };
        }
      ]
      ++ lib.fileset.toList ../profiles;
  }
