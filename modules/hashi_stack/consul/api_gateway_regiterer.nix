{ pkgs, ... }:
let consul_bin = "${pkgs.consul}/bin/consul";
in {

  systemd.services.consul_api_gateway_registerer = {
    path = [ pkgs.getent pkgs.envoy ];
    description = "register consul api gateways";
    script = ''
      ${consul_bin} connect envoy -gateway api -register -service cliarena-gateway
    '';
    serviceConfig = {
      Restart = "on-failure";
      # avoid error start request repeated too quickly sinche RestartSec defaults to 100ms
      RestartSec = 3;
    };
    wantedBy = [ "vault.service" "consul.service" ];
    partOf = [ "vault.service" "consul.service" ];
    after = [ "vault.service" "consul.service" ];
  };
}
