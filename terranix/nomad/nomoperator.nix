{
  time,
  config,
  ...
}: {
  job.nomoperator = {
    datacenters = ["dc1"];

    group.servers = {
      count = 1;

      task.server = {
        driver = "raw_exec";

        config = {
          # TODO: Fix source release to avoid writing "nomoperator-vxx/"
          command = "nomoperator-v1.0/nomoperator";
          args = [
            "bootstrap"
            "git"
            "--url"
            "https://gitlab.com/cliarena_dotfiles/nixos.git"
            "--branch"
            "main"
            "--path"
            "terranix/nomad/jobs/*.tf"
            "--delete"
            "--watch"
            # "--username"
            # "git"
            # "--password"
            # ""
            # "--ssh-key"
            # # "${config.sops.secrets.GH_SSH_KEY.path}"
            # "SSH_KEY"
          ];
        };
        artifacts = [
          {
            source =
              # "https://github.com/jonasvinther/nomad-gitops-operator/releases/download/v0.1.0/nomad-gitops-operator_0.1.0_linux_amd64.tar.gz";
              "https://gitlab.com/clxarena/nomoperator/-/archive/v1.0/nomoperator-v1.0.tar.gz";
            # destination = "local/nomoperator";
            mode = "any";
          }
        ];
        # resources = {
        # cpu = 10;
        # memory = 50;
        # };
      };
    };
  };
}
