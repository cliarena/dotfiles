{ ... }: {
  environment.persistence."/srv" = {
    enable = true; # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/var/lib/systemd/coredump"
      {
        directory = "/var/lib/hydra";
        user = "hydra";
        group = "hydra";
      }
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
      }
    ];
  };
}