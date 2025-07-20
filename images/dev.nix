{lib, pkgs, inputs, ... }:              let
                #     bindsym $mod+Return exec ${pkgs.kitty}/bin/kitty

                sway_cfg = pkgs.writeText "sway_cfg" ''
                       set $mod Mod4   
                       bindsym $mod+Return ${pkgs.execline}/bin/exec ${pkgs.kitty}/bin/kitty
                  #     bindsym $mod+Return exec /run/current-system/sw/bin/kitty

                       bindsym $mod+Shift+q kill
                '';
                menu = "${pkgs.bemenu}/bin/bemenu-run";
                terminal = "${pkgs.wezterm}/bin/wezterm";
                mode = "Alt";
                resolution = "3840x2160";

                # host = rec {
                user = "root";
                wan_ips = [ "10.10.2.222/24" ];
                wan_gateway = [ "10.10.2.1" ];
                is_dns_server = false; # for testing hashi_stack
                dns_server = wan_gateway;
                dns_extra_hosts = "";
                ports = {

                  dns = 53;
                };
                # open the least amount possible
                tcp_ports = with ports; [ dns 8080 ];
                udp_ports = with ports; [ dns ];
                # };
in      
 inputs.nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "docker";

          modules = [

            inputs.home-manager.nixosModules.home-manager
           # ({ pkgs, lib, ... }:
               {
                programs.river.enable = true;

                # Rename network interface to wan
                services.udev.extraRules = ''
                  KERNEL=="e*", NAME="wan"
                '';
                # Disable if this server is a dns server
                services.resolved.enable = false;

                networking = {
                  hostName = user;
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
                      allowedTCPPorts = tcp_ports;
                      allowedUDPPorts = udp_ports;
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
                        address = wan_ips;
                        gateway = wan_gateway;
                        dns = dns_server;
                        # if you want dhcp uncomment this and comment address,gateway and dns
                        # DHCP = "ipv4";
                      };
                    };
                  };
                };

                home-manager.useGlobalPkgs = true; # breaks nixvim
                home-manager.useUserPackages = true;
                home-manager.users."${user}" = {
                  wayland.windowManager.river = {
                    enable = true;
                    settings = {
                      border-width = 1;
                      default-layout = "rivertile";
                      declare-mode = [ "locked" "normal" "passthrough" ];
                      map = {
                        normal = {
                          "${mode} Q" = "close";
                          "${mode}+Shift E" = "exit";
                          "${mode} F" = "toggle-fullscreen";
                          "${mode} F11" = "enter-mode passthrough";

                          "${mode} R" = "spawn ${menu}";
                          "${mode} Return" = "spawn ${terminal}";
                          #         "${mode} D" = "spawn ankama-launcher";
                        };
                        #     // tag_map;
                          passthrough = { "${mode} F11" = "enter-mode normal"; };
                      };
                      set-repeat = "50 300";
                      spawn = [
                        # "${pkgs.brave}/bin/brave"
                        #  "${pkgs.qutebrowser}/bin/qutebrowser"
                        terminal
                        "'${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode ${resolution}'"
                        "'${pkgs.river}/bin/rivertile -view-padding 1 -outer-padding 3'"
                        #  "${pkgs.swww}/bin/swww-daemon"
                        #  "'${pkgs.coreutils}/bin/shuf -zen1 /srv/wallpapers/* | ${pkgs.findutils}/bin/xargs -0 ${pkgs.swww}/bin/swww img'"
                         "'${pkgs.coreutils}/bin/shuf -zen1 /srv/library/wallpapers/* | ${pkgs.findutils}/bin/xargs -0 ${pkgs.wbg}/bin/wbg'"
                        #  "'${pkgs.eww}/bin/eww daemon'"
                        #  "'${pkgs.eww}/bin/eww open-many clock'"
                      ];

                    };
                  };
                  home = {
                    stateVersion = "22.11";
                    username = user;
                    homeDirectory = lib.mkForce "/${user}";
                  };
                  programs.home-manager.enable = true;
                };
                hardware = {
                  graphics.enable = true;
                  graphics.enable32Bit = true;
                  #     uinput.enable = true;
                  #         amdgpu = {
                  #             initrd.enable = true;
                  #          opencl.enable = true;
                };
                #    };
                #   systemd.enableEmergencyMode = lib.mkForce false;
                #     boot = {
                #       plymouth.enable = true;
                #  kernelPackages = pkgs.linuxPackages_latest;
                #    kernelParams = [ "video=1920x1080" "transparent_hugepage=always" ];
                #    initrd = {
                #      systemd.enable = true;
                #  availableKernelModules = [ "amdgpu" ];
                #    };
                #   kernelModules = [
                #     "uinput"];
                #};
                #  services.pulseaudio.enable = lib.mkForce true;
                services.pipewire.enable = true;
                services.pipewire.pulse.enable = true;
                security.rtkit.enable = true;

                #             time.timeZone = "Africa/Casablanca";
                #             i18n.defaultLocale = "en_US.UTF-8";

                environment.systemPackages = with pkgs; [
                  #      cacert

                  #     fuse
                  #     libnss_nis
                  #     wget
                  #     curl
                  #     jq
                  #     gosu

                  #     pulseaudioFull
                  #     noto-fonts
                  #     libGL wayland egl-wayland
                  #     sway
                  kitty
                  nano
                  river

                  #     psmisc

                ];
                #   xdg.portal = {
                #     enable =true;
                #     extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk];
                #   }; 

                systemd.services.desktop = {
                  # enable = false;
                  # description = "desktop runner";
                  path = with pkgs; [ kitty river ];

                  environment = {
                    DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/0/bus";
                    #    WOLF_CFG_FILE = "/srv/wolf/cfg/config.toml";
                    #    WOLF_PRIVATE_KEY_FILE = "/srv/wolf/cfg/key.pem";
                    #    WOLF_PRIVATE_CERT_FILE = "/srv/wolf/cfg/cert.pem";
                    #    HOST_APPS_STATE_FOLDER = "/srv/wolf/state";
                    #    XDG_RUNTIME_DIR = "/run/user/1000";
                    XXX = builtins.getEnv "SALAM";
                    #        XDG_SESSION_TYPE= "wayland";
                    #        WAYLAND_DISPLAY= "wayland-1";
                    #        XDG_RUNTIME_DIR = "/tmp";
                    SWAYSOCK = "/tmp/sway.sock";
                    # For Debuging
                    # GST_DEBUG = "4";
                    # WOLF_LOG_LEVEL = "DEBUG";
                    # RUST_LOG = "DEBUG";
                  };
                  preStart = "${pkgs.coreutils}/bin/env";
                  #  postStart = "${pkgs.coreutils}/bin/sleep 5s && ${pkgs.wlr-randr}/bin/wlr-randr --output WL-1 --custom-mode ${resolution}";

                  #   script = "${pkgs.sway}/bin/sway -c ${sway_cfg}";
                  script = "${pkgs.river}/bin/river";
                  #   script = "${pkgs.kitty}/bin/kitty";
                  serviceConfig = {
                    PassEnvironment =
                      "SALAM XDG_RUNTIME_DIR WAYLAND_DISPLAY XDG_SESSION_TYPE PULSE_SERVER PULSE_SINK PULSE_SOURCE";
                    User = "root";
                    #   Group = "pulse-access";
                    Restart = "on-failure";
                    #   TimeoutSec = 3;
                    # avoid error start request repeated too quickly since RestartSec defaults to 100ms
                    RestartSec = 3;
                  };
                  after = [ "multi-user.target" ];
                  wantedBy = [ "graphical.target" ];
                };

                #          environment.variables = { 
                #           XDG_SESSION_TYPE= "wayland";
                #           WAYLAND_DISPLAY= "wayland-1";
                #          XDG_RUNTIME_DIR = "/tmp";
                #          XXX = builtins.getEnv "SALAM";
                #          };
                #  programs.sway = {
                #    enable = true;

                #    extraSessionCommands = ''
                #      export SWAYSOCK=/tmp/sway.sock
                #      export XDG_CURRENT_DESKTOP=sway
                #      export XDG_SESSIONN_DESKTOP=sway
                #      export XDG_SESSION_TYPE=wayland
                #      export WAYLAND_DISPLAY=wayland-1
                #    '';
                #  };    
                #  services.greetd = {
                #    enable = true;
                # vt = 4;
                #    settings = rec {
                #      initial_session = {
                #      command = "XDG_RUNTIME_DIR=/tmp XDG_SESSION_DESKTOP=sway SWAYSOCK=/tmp/sway.sock XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.firefox}/bin/firefox";

                #        command = "${pkgs.river}/bin/river";
                #       command = "${pkgs.sway}/bin/sway -c ${sway_cfg}";
                #          command = "${pkgs.kitty}/bin/kitty";
                #      command = "${pkgs.coreutils}/bin/env";
                #        user = "svr";
                #     };
                #      default_session = initial_session;
                # };

                # };

                #    services.getty = {
                #      autologinUser = "svr";
                #    };
                #    environment.loginShellInit = ''
                #      [[ "$(tty)" == /dev/tty1 ]] && XDG_RUNTIME_DIR=/tmp XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.sway}/bin/sway
                #   '';
                #     fileSystems."/" = {
                # fsType = "tmpfs";
                # device = "none";
                # options = [
                #   "defaults"
                #   "size=24G" # limit tmpfs size to 24GiB
                #   "noatime"
                # "noexec"
                #   "mode=755"
                # ];
                #};  
                nix = {
                  daemonCPUSchedPolicy =
                    "idle"; # Deprioritizes nix builds for more predictable latencies
                  channel.enable = false; # not needed using flakes
                  # Constrain access to nix daemon
                  settings.allowed-users = [ "@wheel" "hydra" "hydra-www" ];
                  settings.trusted-users = [ "@wheel" "hydra" "hydra-www" ];
                  settings.allowed-uris = [
                    "github:"
                    "https://github.com/"
                    "git+https://github.com/"
                    "git+ssh://github.com/"

                    "gitlab:"
                    "https://gitlab.com/"
                    "git+https://gitlab.com/"
                    "git+ssh://gitlab.com/"
                  ];

                  # Enable Flakes
                  package = pkgs.nixVersions.latest;
                  extraOptions = ''
                    experimental-features = nix-command flakes
                    keep-outputs = true
                    keep-derivations = true
                    warn-dirty = false
                  '';
                };

                users.users."${user}" = {
                  home = lib.mkForce "/root";
                  createHome = true;
                  shell = lib.mkForce pkgs.bashInteractive;
                  uid = lib.mkForce 0;
                  linger = true;
                  isSystemUser = true;
                  initialPassword = "nixos";
                  extraGroups =
                    [ "wheel" "video" "sound" "input" "uinput" "root" ];
                };
                #          _pipewire.enable = true;
                #          _local.enable = true;
              }
#)
          ];

  #      };
 #     };

      # TODO: Change age.key and all sops secrets since age.key is exposed
      # checks = forAllSystems (system:
      #   let
      #     pkgs = import inputs.nixpkgs { inherit system; };
      #     inherit (pkgs) nixosTest;
      #   in {
      #     x = nixosTest (import ./hosts/x/checks.nix { inherit inputs; });
      #     svr = nixosTest (import ./hosts/svr/checks.nix { inherit inputs; });
      #   });
#    };
}
