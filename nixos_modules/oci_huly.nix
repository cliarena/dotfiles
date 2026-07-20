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

  secret = "huly";

  cr_username = "huly";
  cr_secret = "huly";
  cr_db = "huly";
  # cr_db_url = "postgres://${cr_username}:${cr_secret}@cockroach:26257/${cr_db}";
  cr_db_url = "postgres://${cr_username}:${cr_secret}@${host_addr}:5432/${cr_db}";

  s3_addr = "http://${host_addr}:${ports.s3}?accessKey=admin&secretKey=admin";
  ports = {
    front = "7070";
    account = "3000";
    s3 = "3901";
    collaborator = "3078";
    transactor = "3333";
    elasticsearch = "9200";
    fulltext = "4700";
    stats = "4900";
    rekoni = "4004";
    queue = "9092";
  };
in
{
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    # lib.mkForce pkgs.writeShellScript "cockroachdb-single-node"
    # systemd.services.cockroachdb.serviceConfig.ExecStart =
    # lib.mkForce "${pkgs.cockroachdb}/bin/cockroach start-single-node --accept-sql-without-tls --insecure";
    # services.cockroachdb = {
    #   enable = true;
    #   insecure = true;
    #   # extraArgs = [
    #   #   "--accept-sql-without-tls"
    #   # ];
    # };

    services.garage = {
      enable = true;
      package = pkgs.garage_2;
      settings = {
        replication_factor = 1;
        rpc_bind_addr = "[::]:${ports.s3}";

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
        http.cors.allow-origin: "http://${host_addr}:${ports.queue}"
      '';
    };
    services.apache-kafka = {
      enable = true;
      # Replace with a randomly generated uuid. You can get one by running:
      # kafka-storage.sh random-uuid
      clusterId = "69aqkRY2QuS560imxA0e0A";
      formatLogDirs = true;
      settings = {
        listeners = [
          "PLAINTEXT://:${ports.queue}"
          "CONTROLLER://:9093"
        ];
        # Adapt depending on your security constraints
        "listener.security.protocol.map" = [
          "PLAINTEXT:PLAINTEXT"
          "CONTROLLER:PLAINTEXT"
        ];
        "controller.quorum.voters" = [
          "1@127.0.0.1:9093"
        ];
        "controller.listener.names" = [ "CONTROLLER" ];

        "node.id" = 1;
        "process.roles" = [
          "broker"
          "controller"
        ];

        # I prefer to use this directory, because /tmp may be erased
        "log.dirs" = [ "/srv/volumes/kafka" ];
        "offsets.topic.replication.factor" = 1;
        "transaction.state.log.replication.factor" = 1;
        "transaction.state.log.min.isr" = 1;
      };
    };

    # Set this so that systemd automatically create /var/lib/apache-kafka
    # with the right permissions
    systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";
    virtualisation.oci-containers.containers = {
      # redpanda = {
      #   #TODO: Remove privileged
      #   privileged = true;
      #   image = "docker.redpanda.com/redpandadata/redpanda:v24.3.6";
      #   extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
      #   # capabilities = {
      #   #   SYS_NICE = true;
      #   # };
      #   cmd = [
      #     "redpanda"
      #     "start"
      #     "--kafka-addr internal://0.0.0.0:9092,external://0.0.0.0:19092"
      #     "--advertise-kafka-addr internal://${host_addr}:9092,external://localhost:19092"
      #     "--pandaproxy-addr internal://0.0.0.0:8082,external://0.0.0.0:18082"
      #     "--advertise-pandaproxy-addr internal://redpanda:8082,external://localhost:18082"
      #     "--schema-registry-addr internal://0.0.0.0:8081,external://0.0.0.0:18081"
      #     "--rpc-addr redpanda:33145"
      #     "--advertise-rpc-addr redpanda:33145"
      #     "--mode dev-container"
      #     "--smp 1"
      #     "--default-log-level=info"
      #   ];
      #   environment = {
      #     REDPANDA_SUPERUSER_USERNAME = "test";
      #     REDPANDA_SUPERUSER_PASSWORD = "test";
      #   };
      #
      #   ports = [
      #     # TODO: ADD Ports
      #     # "10000:10000/tcp"
      #   ];
      #
      #   volumes = [
      #     "/srv/volumes/redpanda/data:/var/lib/redpanda/data:rw"
      #     # "/nix/store:/nix/store:ro" # to run nixos pkgs
      #     # "/run/current-system/sw/bin:/usr/local/bin:ro" # to access zig pkg
      #     # "/run/current-system/sw/bin:/run/current-system/sw/bin:ro" # to run nixos pkgs
      #   ];
      # };
      huly-rekoni = {
        image = "hardcoreeng/rekoni-service:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SECRET = secret;
        };
      };

      huly-transactor = {
        image = "hardcoreeng/transactor:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SECRET = secret;
          SERVER_PORT = ports.transactor;
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          STORAGE_CONFIG = s3_addr;
          # FRONT_URL = "http://${host_addr}:8087";
          FRONT_URL = "http://${host_addr}:${ports.front}";
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          FULLTEXT_URL = "http://${host_addr}:${ports.fulltext}";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          LAST_NAME_FIRST = "true";
          QUEUE_CONFIG = "${host_addr}:${ports.queue}";
        };
      };

      huly-collaborator = {
        image = "hardcoreeng/collaborator:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SECRET = secret;
          COLLABORATOR_PORT = ports.collaborator;
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          STORAGE_CONFIG = s3_addr;
        };
      };

      huly-account = {
        image = "hardcoreeng/account:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SERVER_SECRET = secret;
          SERVER_PORT = "${ports.account}";
          ACCOUNT_PORT = "${ports.account}";
          DB_URL = cr_db_url;
          TRANSACTOR_URL = "ws://${host_addr}:${ports.transactor};ws://${host_addr}/_transactor";
          FRONT_URL = "http://${host_addr}:${ports.front}";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          MODEL_ENABLED = "*";
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          QUEUE_CONFIG = "${host_addr}:${ports.queue}";
          STORAGE_CONFIG = s3_addr;
        };
      };

      huly-workspace = {
        image = "hardcoreeng/workspace:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          TRANSACTOR_URL = "ws://${host_addr}:${ports.transactor};ws://${host_addr}/_transactor";
          MODEL_ENABLED = "*";
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          ACCOUNTS_DB_URL = cr_db_url;
          FULLTEXT_URL = "http://${host_addr}:${ports.fulltext}";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          QUEUE_CONFIG = "${host_addr}:${ports.queue}";
          STORAGE_CONFIG = s3_addr;
        };
      };

      huly-front = {
        image = "hardcoreeng/front:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SERVER_PORT = "${ports.front}";
          SERVER_SECRET = secret;
          LOVE_ENDPOINT = "http://${host_addr}/_love";
          ACCOUNTS_URL = "http://${host_addr}/_accounts";
          ACCOUNTS_URL_INTERNAL = "http://${host_addr}:${ports.account}";
          REKONI_URL = "http://${host_addr}:${ports.rekoni}";
          CALENDAR_URL = "http://${host_addr}/_calendar";
          GMAIL_URL = "http://${host_addr}/_gmail";
          TELEGRAM_URL = "http://${host_addr}/_telegram";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          UPLOAD_URL = "/files";
          ELASTIC_URL = "http://${host_addr}:${ports.elasticsearch}";
          COLLABORATOR_URL = "ws://${host_addr}:${ports.collaborator}";
          STORAGE_CONFIG = s3_addr;
          TITLE = description;
          DEFAULT_LANGUAGE = "en";
          LAST_NAME_FIRST = "true";
          DESKTOP_UPDATES_CHANNEL = huly_ver;
          DISABLED_FEATURES = "auto-translate,mailboxes";
        };
      };

      huly-fulltext = {
        image = "hardcoreeng/fulltext:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          SERVER_SECRET = secret;
          DB_URL = cr_db_url;
          FULLTEXT_DB_URL = "http://${host_addr}:${ports.elasticsearch}";
          ELASTIC_INDEX_NAME = "huly_storage_index";
          REKONI_URL = "http://${host_addr}:${ports.rekoni}";
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          QUEUE_CONFIG = "${host_addr}:${ports.queue}";
          STORAGE_CONFIG = s3_addr;
        };
      };

      huly-stats = {
        image = "hardcoreeng/stats:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          PORT = ports.stats;
          SERVER_SECRET = secret;
        };
      };

      huly-kvs = {
        image = "hardcoreeng/hulykvs:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          HULY_DB_CONNECTION = cr_db_url;
          HULY_TOKEN_SECRET = secret;
        };
        # ports = [
        #   "8094:8094/tcp"
        # ];
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
