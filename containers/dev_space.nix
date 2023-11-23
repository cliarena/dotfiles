{ lib, inputs, nixpkgs, ... }:
let

  host = rec {
    user = "x";
    hostAddress = "10.10.2.1";
    localAddress = "10.10.2.100";
    wan_ips = [ "${localAddress}/24" ];
    wan_gateway = [ hostAddress ];
    is_dns_server = false; # for testing hashi_stack
    dns_server = wan_gateway;
    dns_extra_hosts = "";
    ssh_authorized_keys = [ ];
    ports = {
      dns = 53;
      ssh = 22;
    };
    # open the least amount possible
    tcp_ports = with ports; [ dns ssh 8080 ];
    udp_ports = with ports; [ dns ];
  };
in {
  # networking.macvlans.mv-lan0-host = {
  # interface = "lan0";
  # mode = "bridge";
  # };
  # networking.interfaces.lan0.ipv4.addresses = lib.mkForce [ ];
  # networking.interfaces.mv-lan0-host = {
  # ipv4.addresses = [{
  # address = host.hostAddress;
  # prefixLength = 24;
  # }];
  # };
  containers.dev-space = {
    inherit (host) hostAddress localAddress;
    autoStart = true;
    privateNetwork = true;
    macvlans = [ "mv-qub0" ];

    # hostAddress = "10.10.2.1";
    # localAddress = "10.10.2.100";
    ephemeral = true;
    bindMounts = {
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }:
      let
        inherit (inputs) home-manager sops-nix;

        configFile = pkgs.writeTextDir "config/sunshine.conf" ''
          origin_web_ui_allowed=wan
        '';
      in {

        nix.extraOptions = ''
          experimental-features = nix-command flakes
          keep-outputs = true
          keep-derivations = true
          warn-dirty = false
        '';
        system.stateVersion = "22.11";

        _module.args.host = host;

        imports = [
          inputs.nixvim.nixosModules.nixvim
          { programs.nixvim = import ../modules/nixvim pkgs; }
          ../modules/fonts
          ../modules/pkgs.nix
          ../modules/chromium.nix
          ../modules/hardware/amd.nix
          ../modules/corectrl.nix
          ../modules/users.nix
          ../modules/netwoking/container-network.nix
          # ../modules/sunshine.nix

          home-manager.nixosModules.home-manager
          {
            inherit nixpkgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.x = {
              imports = [
                sops-nix.homeManagerModules.sops
                ../hosts/x/sops.nix
                # ../modules/home/i3
                ../modules/home/git.nix
                ../modules/home/lazygit.nix
                ../modules/home/ssh.nix
                ../modules/home/shell.nix
                ../modules/home/direnv.nix
                ../modules/home/kitty.nix
                ../modules/home/bottom.nix
              ];
              home = {
                stateVersion = "22.11";
                username = "x";
                homeDirectory = "/home/x";
              };
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              inherit inputs nixpkgs home-manager sops-nix;
            };
          }
        ];
        # modules.services.sunshine.enable = true;
        services.openssh.enable = true;
        environment.systemPackages = with pkgs; [ glxinfo ];
        # services.xserver.enable = true;
        services.xrdp = {
          enable = true;
          openFirewall = true;
          defaultWindowManager = "gnome";
        };
        # services.resolved.enable = true;

        # X and audio
        sound.enable = true;
        hardware.pulseaudio.enable = true;
        security.rtkit.enable = true;

        services.xserver = {
          enable = true;
          # videoDrivers = [ "nvidia" ];

          # Using gdm and gnome
          # lightdm failed to start with autologin, probably linked to X auth and Gnome service conflict
          # X auth was not ready when Gnome session started, can be seen with journalctl _UID=$(id -u sunshine) -b
          # Maybe another combination of displayManager / desktopManager works
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;

          # autologin
          displayManager.autoLogin.enable = true;
          displayManager.autoLogin.user = "x";
          displayManager.defaultSession = "gnome";

          # Dummy screen
          monitorSection = ''
            VendorName     "Unknown"
            HorizSync   30-85
            VertRefresh 48-120

            ModelName      "Unknown"
            Option         "DPMS"
          '';

          deviceSection = ''
            VendorName "NVIDIA Corporation"
            Option      "AllowEmptyInitialConfiguration"
            Option      "ConnectedMonitor" "DFP"
            Option      "CustomEDID" "DFP-0"

          '';

          screenSection = ''
            DefaultDepth    24
            Option      "ModeValidation" "AllowNonEdidModes, NoVesaModes"
            Option      "MetaModes" "1920x1080"
            SubSection     "Display"
                Depth       24
            EndSubSection
          '';
        };

        # Sunshine user, service and config 
        users.users.x = {
          isNormalUser = true;
          home = "/home/x";
          description = "Sunshine Server";
          extraGroups = [ "wheel" "input" "video" "sound" ];
        };

        security.sudo.extraRules = [{
          users = [ "x" ];
          commands = [{
            command = "ALL";
            options = [ "NOPASSWD" ];
          }];
        }];

        security.wrappers.sunshine = {
          owner = "root";
          group = "root";
          capabilities = "cap_sys_admin+p";
          source = "${pkgs.sunshine}/bin/sunshine";
        };

        # Inspired from https://github.com/LizardByte/Sunshine/blob/5bca024899eff8f50e04c1723aeca25fc5e542ca/packaging/linux/sunshine.service.in
        systemd.user.services.sunshine = {
          description = "Sunshine server";
          wantedBy = [ "graphical-session.target" ];
          startLimitIntervalSec = 500;
          startLimitBurst = 5;
          partOf = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart =
              "${config.security.wrapperDir}/sunshine ${configFile}/config/sunshine.conf";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        services.avahi = {
          enable = true;
          reflector = true;
          nssmdns = true;
          publish = {
            enable = true;
            addresses = true;
            userServices = true;
            workstation = true;
          };
        };

      };
  };
}
