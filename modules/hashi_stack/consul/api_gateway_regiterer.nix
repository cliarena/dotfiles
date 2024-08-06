# NOTE: Exposes api-gateway port. otherwise you gateway is useless

{ pkgs, envoy_nixpkgs, ... }:
let consul_bin = "${pkgs.consul}/bin/consul";
in {
  systemd.services.consul_api_gateway_registerer = {
    path = [ pkgs.getent envoy_nixpkgs.envoy ];
    description = "register consul api gateways";
    script = ''
      ${consul_bin} connect envoy -gateway api -register -service cliarena-gateway
    '';
    serviceConfig = {
      Restart = "on-failure";
      # avoid error start request repeated too quickly since RestartSec defaults to 100ms
      RestartSec = 3;
    };
    wantedBy = [ "vault.service" "consul.service" ];
    partOf = [ "vault.service" "consul.service" ];
    after = [ "vault.service" "consul.service" ];
  };
}
