{ time, config, ... }: {
  job.nomoperator = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      task.server = {
        driver = "exec";

        config = {
          command = "nomoperator";
          # args = [
          # "bootstrap"
          # "git"
          # "--url"
          # "https://github.com/jonasvinther/nomad-state.git"
          # "--branch"
          # "main"
          # "--path"
          # "jobs/*.nomad"
          # # "./terranix/nomad/jobs/*.json"
          # ];
          args = [
            "bootstrap"
            "git"
            "--url"
            "git@github.com:jonasvinther/nomad-state.git"
            "--branch"
            "main"
            "--path"
            "/prod-env"
            "--username"
            "git"
            "--password"
            ""
            "--ssh-key"
            # "${config.sops.secrets.GH_SSH_KEY.path}"
            "SSH_KEY"
          ];

        };
        artifacts = [{
          source =
            "https://github.com/jonasvinther/nomad-gitops-operator/releases/download/v0.0.2/nomad-gitops-operator_0.0.2_linux_amd64.tar.gz";
          destination = "local";
          mode = "any";
        }];
        # resources = {
        # cpu = 10;
        # memory = 50;
        # };
      };
    };
  };
}
