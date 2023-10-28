{ inputs, nixpkgs, ... }: let
  host = rec{
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

in {

  containers.dev-space = {
    autoStart = true;
    /* privateNetwork = true; */
    /* hostAddress = "10.10.0.10"; */
    /* localAddress = "10.10.0.100"; */
    ephemeral = true;
    config = { config, pkgs, ... }: let inherit (inputs) home-manager sops-nix ; in{

      nix.extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
        warn-dirty = false
      '';
      system.stateVersion = "22.11";


      imports = [
        inputs.nixvim.nixosModules.nixvim
        { programs.nixvim = import ../modules/nixvim pkgs; }
        ../modules/fonts
        ../modules/pkgs.nix
        ../modules/chromium.nix
        ../modules/hardware/amd.nix
        
    home-manager.nixosModules.home-manager
    {
      inherit nixpkgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.x = { 
      imports = [
    sops-nix.homeManagerModules.sops
    ../hosts/x/sops.nix
    ../modules/home/i3
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
      services.openssh.enable = true;
      environment.systemPackages = with pkgs; [ glxinfo ];
      services.xserver.enable = true;
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
