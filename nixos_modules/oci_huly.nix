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
  # host_addr = "0.0.0.0";
  host_addr = "10.10.2.1";

  secret = "huly";

  cr_username = "huly";
  cr_secret = "huly";
  cr_db = "huly";
  # cr_db_url = "postgres://${cr_username}:${cr_secret}@cockroach:26257/${cr_db}";
  cr_db_url = "postgres://${cr_username}:${cr_secret}@0.0.0.0:5432/${cr_db}";

  s3_addr = "s3|http://${host_addr}:${ports.s3_rpc}?accessKey=${garage.default_access_key}&secretKey=${garage.default_secret_key}";
  ports = {
    front = "7070";
    pulse = "8099";
    account = "3000";
    s3_api_admin = "3903";
    s3_api = "3900";
    s3_rpc = "3901";
    s3_web = "3902";
    collaborator = "3078";
    transactor = "3333";
    elasticsearch = "9200";
    fulltext = "4700";
    stats = "4900";
    rekoni = "4004";
    queue = "9092";
  };

  garage = {

    default_access_key = "GK4ac3b725eeac92db228f6cbcc12fbb7a";
    default_secret_key = "fd40d1b017fbbd35778f48c0cba46a7f05a82a74ffa577aa4c4ae97e70574032";
    rpc_secret = "4425f5c26c5e11581d3223904324dcb5b5d5dfb14e5e7f35e38c595424f5f1e6";
    admin_token = "AepLEqj05hE9vpJnCa1OcxKS99sli7JzuOSjo95LX7A=";
    metrics_token = "RI8gxHo5aLMTsrWdL74uU3tq1wfkLzJSy4DA8tV4gSc=";
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

    systemd.services.garage.serviceConfig.ExecStart =
      lib.mkForce "${config.services.garage.package}/bin/garage server --single-node --default-bucket";
    services.garage = {
      enable = true;
      package = pkgs.garage_2;

      # TODO: Move GARAGE_DEFAULT_ACCESS_KEY_file w/ sops GK"openssl rand -hex 16"
      # TODO: Move GARAGE_DEFAULT_SECRET_KEY_file w/ sops "openssl rand -hex 32"
      extraEnvironment = {
        GARAGE_DEFAULT_BUCKET = "base";
        GARAGE_DEFAULT_ACCESS_KEY = garage.default_access_key;
        GARAGE_DEFAULT_SECRET_KEY = garage.default_secret_key;
      };
      settings = {
        # metadata_dir = "/srv/volumes/garage/meta";
        # data_dir = "/srv/volumes/garage/data";

        db_engine = "sqlite";
        replication_factor = 1;
        rpc_bind_addr = "[::]:${ports.s3_rpc}";
        rpc_public_addr = "${host_addr}:${ports.s3_rpc}";

        # TODO: Move rpc_secret_file w/ sops "openssl rand -hex 32"
        rpc_secret = garage.rpc_secret;

        s3_api = {
          s3_region = "garage";
          api_bind_addr = "[::]:${ports.s3_api}";
          root_domain = ".s3.garage.localhost";
        };
        s3_web = {
          bind_addr = "[::]:${ports.s3_web}";
          root_domain = ".web.garage.localhost";
          index = "index.html";

        };
        admin = {
          api_bind_addr = "[::]:${ports.s3_api_admin}";
          # TODO: Move admin_token_file w/ sops "openssl rand -base64 32"
          admin_token = garage.admin_token;
          # TODO: Move metrics_token_file w/ sops "openssl rand -base64 32"
          metrics_token = garage.metrics_token;

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
          PULSE_URL = "http://${host_addr}:${ports.pulse}";
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
          TRANSACTOR_URL = "ws://${host_addr}:${ports.transactor}";
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
          TRANSACTOR_URL = "ws://${host_addr}:${ports.transactor}";
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
          # ACCOUNTS_URL = "http://${host_addr}/_accounts";
          ACCOUNTS_URL = "http://${host_addr}:${ports.account}";
          ACCOUNTS_URL_INTERNAL = "http://${host_addr}:${ports.account}";
          REKONI_URL = "http://${host_addr}:${ports.rekoni}";
          CALENDAR_URL = "http://${host_addr}/_calendar";
          GMAIL_URL = "http://${host_addr}/_gmail";
          TELEGRAM_URL = "http://${host_addr}/_telegram";
          STATS_URL = "http://${host_addr}:${ports.stats}";
          UPLOAD_URL = "/files";
          ELASTIC_URL = "http://0.0.0.0:${ports.elasticsearch}";
          PULSE_URL = "http://${host_addr}:${ports.pulse}";
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
          FULLTEXT_DB_URL = "http://0.0.0.0:${ports.elasticsearch}";
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
      };

      huly-pulse = {
        image = "hardcoreeng/hulypulse:${huly_ver}";
        extraOptions = [ "--network=host" ]; # Native Performance. Better Than port mapping `ports`
        environment = {
          HULY_BIND_PORT = ports.pulse;
          HULY_LOG = "info";
          HULY_TOKEN_SECRET = secret;
          HULY_HEARTBEAT_TIMEOUT = "60";
          HULY_BACKEND = "memory";
          # For Redis backend instead of in-memory (optional, e.g. multi-node setups):
          # - HULY_BACKEND=redis
          # - HULY_REDIS_MODE=direct
          # - HULY_REDIS_URLS=redis://redis:6379
        };
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
