{ pkgs, ... }:
let consul_bin = "${pkgs.consul}/bin/consul";
in {

  systemd.services.consul = {
    path = [ pkgs.getent ];
    description = "refresh api-gateway http routes";
    preStop = ''
      ${consul_bin} config delete -kind http-route -name cliarena_http_routes
    '';
  };
}
