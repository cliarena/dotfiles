{
  config,
  pkgs,
  NOMAD,
  CONSUL,
  VAULT_ADDR,
  CONSUL_ADDR,
  agent_certs_dir,
  ...
}: let
  # svr.global
  # server.global.nomad
  inherit (builtins) toFile toJSON;
  date = "${pkgs.coreutils}/bin/date";
  consul_bin = "${pkgs.consul}/bin/consul";
  consul-template_bin = "${pkgs.consul-template}/bin/consul-template";

  consul = {
    address = CONSUL_ADDR;
    token_file = config.sops.secrets.CONSUL_HTTP_TOKEN.path;
  };
  vault = {
    address = VAULT_ADDR;
    vault_agent_token_file = config.sops.secrets.VAULT_ROOT_TOKEN.path;
    unwrap_token = false;
    renew_token = false;
  };

  consul_template_cfg =
    toFile "consul-template.hcl" (toJSON {inherit consul vault;});
  consul_certs = rec {
    agent_crt_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/dc1.consul" "common_name=server.dc1.consul" "ttl=24h" "alt_names=localhost" "ip_sans=127.0.0.1"}}
      {{ .Data.certificate }}
      {{ end }}
    '';
    agent_key_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/dc1.consul" "common_name=server.dc1.consul" "ttl=24h" "alt_names=localhost" "ip_sans=127.0.0.1"}}
      {{ .Data.private_key }}
      {{ end }}
    '';
    ca_crt_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/dc1.consul" "common_name=server.dc1.consul" "ttl=24h" "alt_names=localhost"}}
      {{ .Data.issuing_ca }}
      {{ end }}
    '';

    agent_crt = "${agent_crt_tpl}:${CONSUL.cert_file}";
    agent_key = "${agent_key_tpl}:${CONSUL.key_file}";
    ca_crt = "${ca_crt_tpl}:${CONSUL.ca_file}";
  };
  nomad_certs = rec {
    agent_crt_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/global.nomad" "common_name=server.global.nomad" "ttl=24h" "alt_names=localhost" "ip_sans=127.0.0.1"}}
      {{ .Data.certificate }}
      {{ end }}
    '';
    agent_key_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/global.nomad" "common_name=server.global.nomad" "ttl=24h" "alt_names=localhost" "ip_sans=127.0.0.1"}}
      {{ .Data.private_key }}
      {{ end }}
    '';
    ca_crt_tpl = toFile "agent.crt.tpl" ''
      {{ with secret "pki_int/issue/global.nomad" "common_name=server.global.nomad" "ttl=24h" "alt_names=localhost"}}
      {{ .Data.issuing_ca }}
      {{ end }}
    '';

    agent_crt = "${agent_crt_tpl}:${NOMAD.cert_file}";
    agent_key = "${agent_key_tpl}:${NOMAD.key_file}";
    ca_crt = "${ca_crt_tpl}:${NOMAD.ca_file}";
  };
in {
  systemd.services.consul-template = {
    path = [pkgs.getent];
    environment = {inherit VAULT_ADDR;};
    description = "consul-template";
    script = ''
      ${consul-template_bin} -config ${consul_template_cfg} -template ${consul_certs.agent_crt} -template ${consul_certs.agent_key} -template ${consul_certs.ca_crt} -exec ${date} && ${consul_bin} reload
      ${consul-template_bin} -config ${consul_template_cfg} -template ${nomad_certs.agent_crt} -template ${nomad_certs.agent_key} -template ${nomad_certs.ca_crt} -exec ${date} && ${consul_bin} reload
    '';
    wantedBy = ["nomad.service" "vault.service" "consul.service"];
    partOf = ["nomad.service" "vault.service" "consul.service"];
    after = [
      "vault.service"
      "consul.service"
      "sops-nix.service"
      "vault_initializer.service"
    ];
  };
}
