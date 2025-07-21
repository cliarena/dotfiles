{
  description = "Nixos configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/9957cd48326fe8dbd52fdc50dd2502307f188b0d";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {...}: {
    packages.x86_64-linux = {
      retro = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "docker";

        modules = [
          ({
            pkgs,
            lib,
            ...
          }: {
            hardware = {
              graphics.enable = true;
              graphics.enable32Bit = true;
              uinput.enable = true;
            };
            #  services.pulseaudio.enable = lib.mkForce true;
            services.pipewire.enable = true;
            services.pipewire.pulse.enable = true;
            security.rtkit.enable = true;

            time.timeZone = "Africa/Casablanca";
            i18n.defaultLocale = "en_US.UTF-8";

            environment.systemPackages = with pkgs; [
              cacert

              fuse
              libnss_nis
              wget
              curl
              jq
              gosu

              pulseaudioFull
              noto-fonts
              kitty
              nano
              psmisc
            ];
            xdg.portal = {
              enable = true;
              extraPortals = with pkgs; [xdg-desktop-portal xdg-desktop-portal-gtk];
            };

            programs.sway = {
              enable = true;
              extraSessionCommands = ''
                export SWAYSOCK=/tmp/sway.sock
                export XDG_CURRENT_DESKTOP=sway
                export XDG_SESSIONN_DESKTOP=sway
                export XDG_SESSION_TYPE=wayland
              '';
            };
            services.greetd = {
              enable = true;
              # vt = 4;
              settings = rec {
                initial_session = {
                  command = "XDG_RUNTIME_DIR=/tmp XDG_SESSION_DESKTOP=sway SWAYSOCK=/tmp/sway.sock XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.firefox}/bin/firefox";
                  user = "retro";
                };
                default_session = initial_session;
              };
            };

            # services.getty = {
            #   autologinUser = "retro";
            # };
            # environment.loginShellInit = ''
            #   [[ "$(tty)" == /dev/tty1 ]] && XDG_RUNTIME_DIR=/tmp XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY=wayland-1 ${pkgs.sway}/bin/sway
            # '';

            users.users.retro = {
              uid = 1000;
              isNormalUser = true;
              initialPassword = "";
              extraGroups = [
                "wheel"
                "video"
                "sound"
                "input"
                "uinput"
              ];
            };
            #          _pipewire.enable = true;
            #          _local.enable = true;
          })
        ];
      };
    };

    # TODO: Change age.key and all sops secrets since age.key is exposed
    # checks = forAllSystems (system:
    #   let
    #     pkgs = import inputs.nixpkgs { inherit system; };
    #     inherit (pkgs) nixosTest;
    #   in {
    #     x = nixosTest (import ./hosts/x/checks.nix { inherit inputs; });
    #     svr = nixosTest (import ./hosts/svr/checks.nix { inherit inputs; });
    #   });
  };
}
