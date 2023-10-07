{ inputs, ... }: {

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.2.222";
    localAddress = "10.10.2.100";
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
    config = { config, pkgs, ... }: {
      systemd.services.hello = {
        wantedBy = [ "multi-user.target" ];
        script = ''
          while true; do
            echo hello | ${pkgs.netcat}/bin/nc -lN 50
          done
        '';
      };
      networking.firewall.allowedTCPPorts = [ 50 ];

      imports = [
        # ./configuration.nix
        inputs.nixvim.nixosModules.nixvim
        { programs.nixvim = import ../modules/nixvim pkgs; }
      ];

      services.xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = false;
          xfce.enable = true;
        };
      };
      services.xrdp = {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "startxfce4";
      };
      users.users.test = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        initialPassword = "nixos";
        # hashedPassword = "${builtins.readFile ./hpass}";
      };
    };
  };
}
