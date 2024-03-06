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
  inherit (inputs) home-manager sops-nix;
  # consul_bin = "${pkgs.consul}/bin/consul";
in {
  containers.vault-unsealer = {
    # inherit (host) hostAddress localAddress;
    autoStart = true;
    ephemeral = true;

    config = { config, pkgs, ... }: {

      nix.extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
        warn-dirty = false
      '';
      system.stateVersion = "22.11";

      _module.args.host = host;

      imports = [

        home-manager.nixosModules.home-manager
        {
          inherit nixpkgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${host.user} = {
            imports = [ sops-nix.homeManagerModules.sops ../hosts/x/sops.nix ];
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
      ];
      # modules.services.sunshine.enable = true;
      environment.systemPackages = with pkgs; [ vault-bin ];
      # Sunshine user, service and config 
      users.users.${host.user} = {
        isNormalUser = true;
        initialPassword = "nixos";
        openssh.authorizedKeys.keys = host.ssh_authorized_keys;
      };

      security.sudo.extraRules = [{
        users = [ host.user ];
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" ];
        }];
      }];

      services.getty.autologinUser = "x";
      systemd.services.vault_unsealer = {
        path = [ pkgs.getent pkgs.vault-bin ];
        description = "Vault unsealer";
        environment = { VAULT_ADDR = "https://vault.cliarena.com:8200"; };
        script = ''
          for i in {1..3}
          do
             cat /home/${host.user}/.sops/secrets/VAULT_UNSEAL_KEY_$i | xargs vault operator unseal
          done
        '';
        serviceConfig = {
          Restart = "on-failure";
          # avoid error start request repeated too quickly since RestartSec defaults to 100ms
          RestartSec = 3;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
