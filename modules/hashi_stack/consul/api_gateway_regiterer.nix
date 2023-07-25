{ pkgs, ... }:
let consul_bin = "${pkgs.consul}/bin/consul";
in {

  systemd.services.consul_api_gateway_registerer = {
    path = [ pkgs.getent ];
    description = "register consul api gateways";
    script = ''
      ${consul_bin} config delete -kind api-gateway -name cliarena_gateway
      ${consul_bin} connect envoy -gateway api -register -service cliarena_gateway
    '';
    wantedBy = [ "vault.service" "consul.service" ];
    partOf = [ "vault.service" "consul.service" ];
    after = [ "vault.service" "consul.service" ];
  };
}
