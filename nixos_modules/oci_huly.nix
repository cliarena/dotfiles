{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = "_oci_huly";
  description = "Huly Project Manager";
  inherit (lib) mkEnableOption mkIf;

  huly_ver = "v0.7.426";
  host_addr = "0.0.0.0";

  secret = "test";

  cr_username = "test";
  cr_secret = "test";
  cr_db = "test";
  cr_db_url = "postgres://${cr_username}:${cr_secret}@cockroach:26257/${cr_db}";
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    # lib.mkForce pkgs.writeShellScript "cockroachdb-single-node"
    systemd.services.cockroachdb.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.cockroachdb}/bin/cockroach start-single-node --accept-sql-without-tls --insecure";
    services.cockroachdb = {
      enable = true;
      insecure = true;
      # extraArgs = [
      #   "--accept-sql-without-tls"
      # ];
    };

    services.garage = {
      enable = true;
      package = pkgs.garage_2;
      settings = {
        replication_factor = 1;
        rpc_bind_addr = "[::]:3901";

        # TODO: Move rpc_secret_file w/ sops
        rpc_secret = "4425f5c26c5e11581d3223904324dcb5b5d5dfb14e5e7f35e38c595424f5f1e6";

        s3_api = {
          s3_region = "garage";
        };
      };
    };
    services.elasticsearch = {
      enable = true;
      plugins = [ pkgs.elasticsearchPlugins.ingest-attachment ];
      extraConf = ''
        http.cors.enabled: true
        http.cors.allow-origin: "http://localhost:8082"
      '';
    };
    virtualisation.oci-containers.containers = {
      redpanda = {
        #TODO: Remove privileged
        privileged = true;
        image = "docker.redpanda.com/redpandadata/redpanda:v24.3.6";
        # capabilities = {
        #   SYS_NICE = true;
        # };
        cmd = [
          "redpanda"
          "start"
          "--kafka-addr internal://0.0.0.0:9092,external://0.0.0.0:19092"
          "--advertise-kafka-addr internal://redpanda:9092,external://localhost:19092"
          "--pandaproxy-addr internal://0.0.0.0:8082,external://0.0.0.0:18082"
          "--advertise-pandaproxy-addr internal://redpanda:8082,external://localhost:18082"
          "--schema-registry-addr internal://0.0.0.0:8081,external://0.0.0.0:18081"
          "--rpc-addr redpanda:33145"
          "--advertise-rpc-addr redpanda:33145"
          "--mode dev-container"
          "--smp 1"
          "--default-log-level=info"
        ];
        environment = {
          REDPANDA_SUPERUSER_USERNAME = "test";
          REDPANDA_SUPERUSER_PASSWORD = "test";
        };

        ports = [
          # TODO: ADD Ports
          # "10000:10000/tcp"
        ];

        volumes = [
          # "/srv/volumes/redpanda:/var/lib/redpanda/data:rw"
          # "/nix/store:/nix/store:ro" # to run nixos pkgs
          # "/run/current-system/sw/bin:/usr/local/bin:ro" # to access zig pkg
          # "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs
        ];
      };
      huly-reckoni = {
        image = "hardcoreeng/rekoni-service:${huly_ver}";
        environment = {
          SECRET = secret;
        };
      };

      huly-transactor = {
        image = "hardcoreeng/transactor:${huly_ver}";
        environment = {
          SECRET = secret;
          SERVER_PORT = "3333";
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
          FRONT_URL = "http://localhost:8087";
          ACCOUNTS_URL = "http://account:3000";
          FULLTEXT_URL = "http://fulltext:4700";
          STATS_URL = "http://stats:4900";
          LAST_NAME_FIRST = "true";
          QUEUE_CONFIG = "redpanda:9092";
        };
      };

      huly-collaborator = {
        image = "hardcoreeng/collaborator:${huly_ver}";
        environment = {
          SECRET = secret;
          COLLABORATOR_PORT = "3078";
          ACCOUNTS_URL = "http://account:3000";
          STATS_URL = "http://stats:4900";
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
        };
      };

      huly-account = {
        image = "hardcoreeng/account:${huly_ver}";
        environment = {
          SERVER_SECRET = secret;
          SERVER_PORT = "3000";
          DB_URL = cr_db_url;
          TRANSACTOR_URL = "ws://transactor:3333;ws://${host_addr}/_transactor";
          FRONT_URL = "http://${host_addr}";
          STATS_URL = "http://${host_addr}/_stats";
          MODEL_ENABLED = "*";
          ACCOUNTS_URL = "http://${host_addr}/_accounts";
          ACCOUNT_PORT = "3000";
          QUEUE_CONFIG = "redpanda:9092";
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
        };
      };

      huly-workspace = {
        image = "hardcoreeng/workspace:${huly_ver}";
        environment = {
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          TRANSACTOR_URL = "ws://transactor:3333;ws://${host_addr}/_transactor";
          MODEL_ENABLED = "*";
          ACCOUNTS_URL = "http://account:3000";
          ACCOUNTS_DB_URL = cr_db_url;
          FULLTEXT_URL = "http://fulltext:4700";
          STATS_URL = "http://stats:4900";
          QUEUE_CONFIG = "redpanda:9092";
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
        };
      };

      huly-front = {
        image = "hardcoreeng/front:${huly_ver}";
        environment = {
          SERVER_PORT = "8080";
          SERVER_SECRET = secret;
          LOVE_ENDPOINT = "http://${host_addr}/_love";
          ACCOUNTS_URL = "http://${host_addr}/_accounts";
          ACCOUNTS_URL_INTERNAL = "http://account:3000";
          REKONI_URL = "http://${host_addr}/_rekoni";
          CALENDAR_URL = "http://${host_addr}/_calendar";
          GMAIL_URL = "http://${host_addr}/_gmail";
          TELEGRAM_URL = "http://${host_addr}/_telegram";
          STATS_URL = "http://${host_addr}/_stats";
          UPLOAD_URL = "/files";
          ELASTIC_URL = "http://elastic:9200";
          COLLABORATOR_URL = "ws://${host_addr}/_collaborator";
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
          TITLE = description;
          DEFAULT_LANGUAGE = "en";
          LAST_NAME_FIRST = "true";
          DESKTOP_UPDATES_CHANNEL = huly_ver;
          DISABLED_FEATURES = "auto-translate,mailboxes";
        };
      };

      huly-fulltext = {
        image = "hardcoreeng/fulltext:${huly_ver}";
        environment = {
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          FULLTEXT_DB_URL = "http://elastic:9200";
          ELASTIC_INDEX_NAME = "huly_storage_index";
          REKONI_URL = "http://rekoni:4004";
          ACCOUNTS_URL = "http://account:3000";
          STATS_URL = "http://stats:4900";
          QUEUE_CONFIG = "redpanda:9092";
          STORAGE_CONFIG = "minio|minio?accessKey=minioadmin&secretKey=minioadmin";
        };
      };

      huly-stats = {
        image = "hardcoreeng/stats:${huly_ver}";
        environment = {
          PORT = "4900";
          SERVER_SECRET = secret;
        };
      };

      huly-kvs = {
        image = "hardcoreeng/hulykvs:${huly_ver}";
        environment = {
          HULY_DB_CONNECTION = cr_db_url;
          HULY_TOKEN_SECRET = secret;
        };
        ports = [
          "8094:8094/tcp"
        ];
      };

    };

    # systemd.services.podman-wolf.serviceConfig = {
    #   # User = "root";
    #   Group = "pulse-access";
    #   Restart = "on-failure";
    #   TimeoutSec = 3;
    #   # avoid error start request repeated too quickly since RestartSec defaults to 100ms
    #   RestartSec = 3;
    # };
  };
}
