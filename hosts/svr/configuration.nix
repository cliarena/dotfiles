{ inputs, pkgs, ... }:
let inherit (inputs) sops-nix disko;
in {
  imports = [
    sops-nix.nixosModules.sops
    disko.nixosModules.disko
    ./sops.nix
    ../../modules/nix_config.nix
    (import ./disko.nix { }) # doesn't support btrfs swapfile
    ../../modules/swap.nix
    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/users.nix
    ../../modules/i18n.nix
    # ../../modules/sshd.nix
    ../../modules/netwoking/router.nix
    ../../modules/auditd.nix
    ../../modules/hashi_stack
    ../../containers/dev_space.nix
    ../../containers/hello.nix
    ../../modules/pkgs.nix
  ];

      environment.systemPackages = with pkgs; [ xterm xorg.xhost ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
    services.xserver.windowManager.i3 = {
      enable = true;
       configFile = import ../../modules/i3/default.nix { };
      /* configFile = ../modules/i3/config; */
    };
  system.stateVersion = "22.11";
}
