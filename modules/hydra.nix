{ ... }: {
  services.hydra = {
    enable = true;
    hydraURL = "http://0.0.0.0:9999";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
}
