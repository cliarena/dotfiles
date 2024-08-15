{ ... }: {
  services.hydra = {
    enable = true;
    hydraURL = "http://hydra.cliarena.com";
    port = 9999;
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    extraEnv = { HYDRA_DATA = "/srv/hydra"; };
  };
}
