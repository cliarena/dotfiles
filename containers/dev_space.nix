{ lib, inputs, nixpkgs, ... }:
let

  inherit (inputs) home-manager sops-nix;
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

    specialArgs = { inherit inputs nixpkgs home-manager host; };

    autoStart = true;
    interfaces = [ "mv-qub0" ];
    # TODO: Test if it's needed BY SUNSHIN
    # additionalCapabilities = [ "CAP_SYS_ADMIN" ];

    # hostAddress = "10.10.2.1";
    # localAddress = "10.10.2.100";
    restartIfChanged = false;
    ephemeral = true;

    # INFO: you need to bindmount your devices and add each device to allowedDevices
    bindMounts = {
      "/srv" = { # needed for sops
        hostPath = "/srv";
        isReadOnly = false;
      };
      "/var/lib/acme" = { # needed for terraform certs consul_config_entry
        hostPath = "/var/lib/acme";
        isReadOnly = true;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };
      "/dev/fb0" = {
        hostPath = "/dev/fb0";
        isReadOnly = false;
      };
      # TODO: Test if it's needed by sunshine to forward mouse and keyboard events
      "/dev/input" = {
        hostPath = "/dev/input";
        isReadOnly = false;
      };
      "/dev/uinput" = {
        hostPath = "/dev/uinput";
        isReadOnly = false;
      };
      "/run/udev" = {
        hostPath = "/run/udev";
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
      # TODO: fix dual gpu sunshine errors
      {
        modifier = "rw";
        node = "/dev/dri/card1";
      }
      {
        modifier = "rw";
        node = "/dev/dri/renderD129";
      }
      # {
      # modifier = "rw";
      # node = "/dev/fb0";
      # }
      {
        modifier = "rwm";
        node = "/dev/uinput";
      }
      {
        modifier = "rwm";
        node = "char-input";
      }
    ];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.11";

      imports = [
        ../modules/sshd.nix
        ../modules/chromium.nix
        ../modules/hardware/amd.nix
        # ../modules/surrealdb.nix
        # ../modules/users.nix
        ../modules/netwoking/container-network.nix
        ../modules/boot/amd.nix

        home-manager.nixosModules.home-manager
        {
          inherit nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${host.user} = {
            imports = [
              sops-nix.homeManagerModules.sops
              ../hosts/x/sops.nix
              ../modules/home/git.nix
              ../modules/home/lazygit.nix
              ../modules/home/ssh.nix
              ../modules/home/shell.nix
              ../modules/home/direnv.nix
              ../modules/home/kitty.nix
              ../modules/home/bottom.nix
              ../modules/home/taskwarrior.nix
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
            inherit inputs nixpkgs home-manager sops-nix;
          };
        }
      ] ++ lib.fileset.toList ../profiles;

      profiles.common.enable = true;
      profiles.desktop.enable = true;
      # modules.services.sunshine.enable = true;
      environment.sessionVariables = { TIMEWARRIORDB = "/srv/timewarrior"; };
      environment.systemPackages = with pkgs; [ glxinfo ];
      # services.xserver.enable = true;
      services.xrdp = {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "gnome";
      };
      # services.resolved.enable = true;

      services.xserver = {
        enable = true;
        # videoDrivers = [ "amdgpu" ];

        # Using gdm and gnome
        # lightdm failed to start with autologin, probably linked to X auth and Gnome service conflict
        # X auth was not ready when Gnome session started, can be seen with journalctl _UID=$(id -u sunshine) -b
        # Maybe another combination of displayManager / desktopManager works
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        # autologin
        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = host.user;
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

      # # Sunshine user, service and config
      # users.users.${host.user} = {
      # isNormalUser = true;
      # initialPassword = "nixos";
      # extraGroups = [
      # "avahi" # needed to read /var/lib/acme files for terranix apply
      # "wheel"
      # "input"
      # "video"
      # "sound"
      # ];
      # shell = pkgs.nushell;
      # openssh.authorizedKeys.keys = host.ssh_authorized_keys;
      # };
      # security.sudo.extraRules = [{
      # users = [ host.user ];
      # commands = [{
      # command = "ALL";
      # options = [ "NOPASSWD" ];
      # }];
      # }];

    };
  };
}
