{time, ...}: let
  http = {
    mode = "bridge";
    reservedPorts.http = {
      static = 4646;
      to = 443;
    };
  };
in {
  job.nomad_proxy = {
    datacenters = ["dc1"];
    # namespace = "nomad_proxy";

    type = "service";

    group.proxy = {
      # Only 1
      count = 1;

      network = {
        mode = "host";
        port.http = {
          static = 4646;
          to = 443;
        };
      };

      services = [
        {
          name = "nomad_ops";
          tags = ["http" "view"];

          port = "http";

          checks = [
            {
              type = "http";
              path = "/api/health";
              interval = "10s";
              timeout = "2s";
            }
          ];
        }
      ];

      # Create an individual task (unit of work). This particular
      # task utilizes a Docker container to front a web application.
      task.operator = {
        # Specify the driver to be "docker". Nomad supports
        # multiple drivers.
        driver = "docker";

        # available with nomad >=v1.5.0
        # use manually supplied NOMAD_TOKEN before that
        identity = {
          # Expose Workload Identity in NOMAD_TOKEN env var
          #env = true

          # Expose Workload Identity in ${NOMAD_SECRETS_DIR}/nomad_token file
          file = true;
        };

        env = {
          NOMAD_OPS_LOCAL_REPO_DIR = "/data/repos";

          # Adjust accordingly
          NOMAD_ADDR = "http://host.docker.internal:4646";
          # comment and provide a NOMAD_TOKEN instead
          NOMAD_TOKEN_FILE = "${NOMAD_SECRETS_DIR}/nomad_token";

          TRACE = "FALSE";
        };

        # Configuration is specific to each driver.
        config = {
          image = "ghcr.io/nomad-ops/nomad-ops:main";
          args = [
            "serve"
            "--http"
            "0.0.0.0:${NOMAD_PORT_http}"
            "--dir"
            "/data/pb_data"
          ];

          ports = ["http"];

          mounts = [
            {
              type = "volume";
              target = "/data";
              source = "nomad-ops-data";
            }
          ];
        };

        # Specify the maximum resources required to run the task,
        # include CPU, memory, and bandwidth.
        resources = {
          cpu = 200; # MHz
          memory = 500; # MB
        };
      };
    };
  };
}
