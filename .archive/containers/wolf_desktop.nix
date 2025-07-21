{
  lib,
  inputs,
  nixpkgs,
  ...
}: let
  host = rec {user = "x";};
in {
  containers.wolf-desktop = {
    autoStart = false;
    ephemeral = true;

    # INFO: you need to bindmount your devices and add each device to allowedDevices
    bindMounts = {
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
      {
        modifier = "rwm";
        node = "/dev/uinput";
      }
      {
        modifier = "rwm";
        node = "char-input";
      }
    ];

    config = {
      config,
      pkgs,
      ...
    }: let
      inherit (inputs) home-manager sops-nix;
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
        {programs.nixvim = import ../modules/nixvim pkgs;}
        ../modules/pkgs.nix
        ../modules/chromium.nix
        ../modules/hardware/amd.nix
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
            ];
            home = {
              stateVersion = "22.11";
              username = "x";
              homeDirectory = "/home/${host.user}";
            };
          };
          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit inputs nixpkgs home-manager sops-nix;
          };
        }
      ];
      services.openssh.enable = true;
      environment.systemPackages = with pkgs; [glxinfo];

      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = host.user;
        displayManager.defaultSession = "gnome";
      };
      # Needed for auto login
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      users.users.${host.user} = {
        isNormalUser = true;
        initialPassword = "nixos";
        extraGroups = ["wheel" "input" "video" "sound"];
        shell = pkgs.nushell;
      };

      security.sudo.extraRules = [
        {
          users = [host.user];
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
