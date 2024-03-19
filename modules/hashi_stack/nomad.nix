{ config, pkgs, NOMAD, CONSUL, CONSUL_ADDR, VAULT_ADDR, ... }: {
  services.nomad = {
    enable = true;
    # needed by Podman driver maybe others too
    dropPrivileges = false;
    enableDocker = true;
    extraPackages = [
      # needed for service mesh
      pkgs.cni-plugins
      # needed eved if consul is running as a service
      pkgs.consul
    ];

    # extraSettingsPlugins = [ pkgs.nomad-driver-podman ];
    extraSettingsPaths =
      [ config.sops.secrets."NOMAD_GOSSIP_ENCRYPTION_KEY.hcl".path ];
    settings = {
      data_dir = "/srv/nomad/data";
      ui = {
        enabled = true;
        consul = { ui_url = "${CONSUL_ADDR}/ui"; };
        vault = { ui_url = "${VAULT_ADDR}/ui"; };
      };
      plugin.docker = { config = { allow_privileged = true; }; };

      # vault = {
      # enabled = true;
      # address = "http://vault.cliarena.com:8200";
      # };
      # # FIX: enable after setting up api gateway
      # tls = {
      # # http = true;
      # rpc = true;
      # # /var/lib/acme/cliarena.com/cert.pem
      # inherit (NOMAD) ca_file cert_file key_file;
      # # ca_file = "/etc/certs/ca.crt";
      # # cert_file = "/etc/certs/nomad.crt";
      # # key_file = "/var/lib/acme/cliarena.com/key.pem";
      # verify_server_hostname = true;
      # # FIX: enable after setting up api gateway
      # # verify_https_client = true;
      # };

      # Needed so nomad uses https and grpc_tls to communicate with consul
      # consul = {
      # address = "127.0.0.1:8500";
      # # FIX: enable after setting up api gateway
      # inherit (CONSUL) grpc_ca_file ca_file cert_file key_file;
      # grpc_address = "127.0.0.1:8503";
      # ssl = true;
      # };

      server = {
        enabled = true;
        bootstrap_expect = 1; # for demo; no fault tolerance
        # able to access sops secrets because dropPrivileges =  false;
      };

      client = {
        enabled = true;
        cni_path = "${pkgs.cni-plugins}/bin";

        # cpu_total_compute = 4 * 2200;
        memory_total_mb = 2 * 64 * 1024; # double the ram to benefit from zram
        host_volume = {
          nix_store = {
            path = "/nix/store";
            read_only = true;
          };
          ## WOLF ##
          wolf = {
            path = "/srv/wolf";
            read_only = false;
          };
          tmp_sockets = {
            path = "/tmp/sockets";
            read_only = false;
          };
          docker_socket = {
            path = "/var/run/docker.sock";
            read_only = false;
          };
          shared_mem = {
            path = "/dev/shm";
            read_only = false;
          };
          dev_input = {
            path = "/dev/input";
            read_only = false;
          };
          udev = {
            path = "/run/udev";
            read_only = false;
          };
          ## WOLF end ##
          # certs_fullchain = {
          #   path = "/srv/certs/fullchain.pem";
          #   read_only = true;
          # };
          # certs_privkey = {
          #   path = "/srv/certs/privkey.pem";
          #   read_only = true;
          # };
          # taskserver_data = {
          #   path = "/srv/taskserver/data";
          #   read_only = false;
          # };
          # vaultwarden = {
          # path = "/vault/hdd/nomad/host-volumes/vaultwarden";
          # read_only = false;
          # };
          # for kasm itself
          # kasm_data = {
          #   path = "/srv/kasm/data";
          #   read_only = false;
          # };
          # # for kasm profiles data persistency
          # kasm_profiles = {
          #   path = "/srv/kasm/profiles";
          #   read_only = false;
          # };
          # waypoint-server = {
          # path = "/vault/hdd/nomad/host-volumes/wp-server";
          # read_only = false;
          # };
          # waypoint-runner = {
          # path = "/vault/hdd/nomad/host-volumes/wp-runner";
          # read_only = false;
          # };
        };
      };
    };
  };
}
