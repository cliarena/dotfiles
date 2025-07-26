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
in
  inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    format = "docker";
    specialArgs = {
      inherit inputs;
      inherit (inputs) nixpkgs home-manager;
      inherit host;
    };
    modules =
      [
        ../modules/boot/amd.nix
        ../modules/hardware/amd.nix

        {
          systemd.oomd.enable = false;

          #  services.resolved.enable = false;

          #  networking = {
          #    hostName = host.user;
          #    extraHosts = "127.0.0.1 local.cliarena.com";
          #    useDHCP = false;
          #    useNetworkd = true;
          #    resolvconf.enable = pkgs.lib.mkForce false;
          #    dhcpcd.extraConfig = "nohook resolv.conf";
          #    networkmanager.dns = "none";
          #    firewall = {
          #      enable = false;
          #      interfaces.wan = {
          #        allowedTCPPorts = host.tcp_ports;
          #        allowedUDPPorts = host.udp_ports;
          #      };
          #    };
          #  };
          #  systemd = {
          #    network = {
          #      enable = true;
          #    };
          #  };

          #   home-manager.users."${host.user}" = {
          #     home = {
          #       stateVersion = "22.11";
          #       username = host.user;
          #       homeDirectory = lib.mkForce "/${host.user}";
          #     };
          #   };

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
            after = ["multi-user.target"];
            wantedBy = ["graphical.target"];
            #    after = ["getty@tty1.service"];
          };

          users.users."${host.user}" = {
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

          #    systemd.services.desktop = {
          # enable = false;
          #      description = "desktop runner";
          #      path = with pkgs; [river];

          #      environment = {
          #        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/0/bus";
          #        PATH = lib.mkForce "/run/wrappers/bin:/root/.nix-profile/bin:/nix/profile/bin:/root/.local/state/nix/profile/bin:/etc/profiles/per-user//bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
          #      };
          # preStart = "${pkgs.coreutils}/bin/env";
          #      script = "${pkgs.river}/bin/river";
          #      serviceConfig = {
          #        PassEnvironment = "XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
          #        User = "root";
          #        Restart = "on-failure";
          #   TimeoutSec = 3;
          # avoid error start request repeated too quickly since RestartSec defaults to 100ms
          #        RestartSec = 3;
          #      };
          #      after = ["multi-user.target"];
          #      wantedBy = ["graphical.target"];
          #    };

          #    users.users."${host.user}" = {
          #      home = lib.mkForce "/root";
          #      createHome = true;
          #      uid = lib.mkForce 0;
          # linger = true; # lingering disables home-manager services fromm ruunning on login
          #      isSystemUser = lib.mkForce true;
          #      isNormalUser = lib.mkForce false;
          #      initialPassword = "nixos";
          # shell = lib.mkForce pkgs.bashInteractive;
          #      shell = lib.mkForce pkgs.nushell;
          #      extraGroups = ["wheel" "video" "sound" "input" "uinput"];
          #    };

          _home_gitter.enable = true;
          profiles.common.enable = true;
          profiles.desktop.enable = true;
        }
      ]
      ++ lib.fileset.toList ../profiles;
  }
