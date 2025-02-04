{ time, config, ... }: {
  job.nomoperator = {
    datacenters = [ "dc1" ];

    group.servers = {
      count = 1;

      task.server = {
        driver = "raw_exec";

        config = {
          command = "nomoperator";
          # command =
          # "nomoperator bootstrap git --url https://gitlab.com/cliarena_dotfiles/nixos.git --branch main --path terranix/nomad/jobs/*.json";
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
            "https://gitlab.com/cliarena_dotfiles/nixos.git"
            "--branch"
            "main"
            "--path"
            "terranix/nomad/jobs/*.nomad"
            # "--username"
            # "git"
            # "--password"
            # ""
            # "--ssh-key"
            # # "${config.sops.secrets.GH_SSH_KEY.path}"
            # "SSH_KEY"
          ];

        };
        artifacts = [{
          source =
            "https://github.com/jonasvinther/nomad-gitops-operator/releases/download/v0.1.1/nomad-gitops-operator_0.1.1_linux_amd64.tar.gz";
          # destination = "local/nomoperator";
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
