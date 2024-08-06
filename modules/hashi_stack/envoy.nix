{ envoy_nixpkgs, ... }: {
  services.envoy = {
    package = envoy_nixpkgs.envoy;
    enable = true;
  };
}
