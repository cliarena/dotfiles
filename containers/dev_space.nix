{ inputs, nixpkgs, ... }: let
  
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

in {

  containers.dev-space = {
    autoStart = true;
    /* privateNetwork = true; */
    /* hostAddress = "10.10.0.10"; */
    /* localAddress = "10.10.0.100"; */
    ephemeral = true;
    # bindMounts = {
    # "/nix/store" = {
    # hostPath = "/nix/store";
    # isReadOnly = true;
    # };
    # };
    # hostAddress6 = "fc00::1";
    # localAddress6 = "fc00::2";
    # config = { config, pkgs, ... }: {
    # # services.nextcloud = {
    # # enable = true;
    # # package = pkgs.nextcloud27;
    # # hostName = "localhost";
    # # config.adminpassFile = "${pkgs.writeText "adminpass"
    # # "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
    # # };
    # systemd.services.hello = {
    # wantedBy = [ "multi-user.target" ];
    # script = ''
    # while true; do
    # echo salam | ${pkgs.netcat}/bin/nc -lN 50
    # done
    # '';
    # };
    # networking.firewall.allowedTCPPorts = [ 50 ];
    # # system.stateVersion = "23.05";
    # # networking = {
    # # firewall = {
    # # enable = true;
    # # allowedTCPPorts = [ 80 ];
    # # };
    # # # Use systemd-resolved inside the container
    # # # useHostResolvConf = mkForce false;
    # # };
    # # services.resolved.enable = true;
    # };
      bindMounts = {
        /* "/home/.mozilla" = { */
        /*   hostPath = "/home/browser/.mozilla"; */
        /*   isReadOnly = false; */
        /* }; */
        /* "/home/.cache" = { */
        /*   hostPath = "/home/browser/.cache"; */
        /*   isReadOnly = false; */
        /* }; */
        /* "/home/Downloads" = { */
        /*   hostPath = "/home/admin/Downloads"; */
        /*   isReadOnly = false; */
        /* }; */
        "/tmp/.X11-unix".hostPath = "/tmp/.X11-unix";
        "/dev/dri" = {
          hostPath = "/dev/dri";
          isReadOnly = false;
        };
        "/dev/shm" = {
          hostPath = "/dev/shm";
          isReadOnly = false;
        };
      };
      extraFlags = [ "-E DISPLAY=:0" "--resolv-conf=replace-uplink" ]; 
    config = { config, pkgs, ... }: let inherit (inputs) home-manager hyprland; in{

      nix.extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
        warn-dirty = false
      '';
      systemd.services.hello = {
        wantedBy = [ "multi-user.target" ];
        script = ''
          while true; do
            echo hello | ${pkgs.netcat}/bin/nc -lN 50
          done
        '';
      };
      /* systemd.services.vnc = { */
      /*   wantedBy = [ "multi-user.target" ]; */
      /*   script = '' */
      /*     ${pkgs.wayvnc}/bin/wayvnc */
      /*   ''; */
      /* }; */
      /* networking.firewall.allowedTCPPorts = [ 50 ]; */
      /* networking.resolvconf.enable = pkgs.lib.mkForce false; */
system.stateVersion = "22.11";


      imports = [
        # ./configuration.nix
        inputs.nixvim.nixosModules.nixvim
        { programs.nixvim = import ../modules/nixvim pkgs; }
        /* ../modules/pkgs.nix */
        /* ../modules/gnome.nix */
        ../modules/hardware/amd.nix
        
/*     home-manager.nixosModules.home-manager */
/*     { */
/*       inherit nixpkgs; */
/*       home-manager.useGlobalPkgs = true; */
/*       home-manager.useUserPackages = true; */
/*       home-manager.users.x = {  */
/*       imports = [ */
/*     hyprland.homeManagerModules.default */
/*     ../modules/home/hyprland */
/**/
      ];
services.xserver.windowManager.i3= {
enable = true;
  configFile = import ../modules/i3 {};
        };
/**/
/*   home = { */
/*     stateVersion = "22.11"; */
/*     username = "x"; */
/*     homeDirectory = "/home/x"; */
/*   }; */
/*   }; */
/*       # Optionally, use home-manager.extraSpecialArgs to pass */
/*       # arguments to home.nix */
/*       home-manager.extraSpecialArgs = { */
/*         inherit inputs nixpkgs home-manager ; */
/*       */
/*       }; */
/*     } */
      /* ]; */
        /* hardware.opengl.enable = true; */
      services.x2goserver = { enable = true; };
      services.openssh.enable = true;
      environment.systemPackages = with pkgs; [ xterm kitty chromium glxinfo ];
      /* services.xserver.enable = true; */
      /* services.xserver.videoDrivers = [ "amdgpu" ]; */
    /* services.xserver.windowManager.i3 = { */
    /*   enable = true; */
    /*    configFile = import ../modules/i3/default.nix { }; */
    /* configFile = ../modules/i3/config; */ 
    /* }; */

      /* }; */
        /* programs.hyprland = { */
          /* enable = true; */
          # configFile = import ../modules/i3/default.nix { };
          /* configFile = ../modules/i3/config; */
        /* }; */
      services.xrdp = {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "i3";
      };
      users.users.x = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        initialPassword = "nixos";
        # hashedPassword = "${builtins.readFile ./hpass}";
      };
    };
  };
}
