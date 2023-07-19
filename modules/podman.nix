{ ... }: {
  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
