{
  config,
  lib,
  inputs,
  host,
  ...
}: let
  module = "_powerdns";
  description = "powerdns domain name server";
  inherit (lib) mkEnableOption mkIf;

  inherit (inputs) self;
  bind_0_0_127_arpa = builtins.toFile "bind_0_0_127_arpa" ''
    $TTL 2d
    0.0.127.in-addr.arpa.   IN    SOA   ns.cliarena.com.   reporter.cliarena.com. (
                                  ${
      builtins.toString
      self.sourceInfo.lastModified
    }
                                  12h
                                  15m
                                  3w
                                  2h
                                  )
                      IN    NS    ns.cliarena.com.

    131               IN    PTR   vault.cliarena.com
  '';

  bind_cliarena-zone = builtins.toFile "bind_cliarena-zone" ''
    $TTL 2d
    $ORIGIN cliarena.com.
    @                 IN    SOA   ns.cliarena.com.   reporter.cliarena.com. (
                                  ${
      builtins.toString
      self.sourceInfo.lastModified
    }
                                  12h
                                  15m
                                  3w
                                  2h
                                  )
                      IN    NS    ns.cliarena.com.
    ns                IN    A     ${host.ip_addr}

    @                 IN    A     ${host.ip_addr}
    *                 IN    A     ${host.ip_addr}
  '';
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.pdns-recursor = {
      enable = true;
      exportHosts = true;
      forwardZones = {
        consul = "127.0.0.1:8600";
        # "m7an.com" = "127.0.0.1:5353";
        "cliarena.com" = "127.0.0.1:5353";

        "0.0.127.in-addr.arpa" = "127.0.0.1:5353";
        # "youtube.com" = "127.0.0.1:5353";
      };
      dnssecValidation = "off";
    };
    services.powerdns = {
      enable = true;
      extraConfig = ''
        launch=bind
        local-address=0.0.0.0:5353, [::1]:5353
        bind-config=${
          builtins.toFile "bind-backend" ''

            zone "cliarena.com" IN {
              type master;
             file "${bind_cliarena-zone}";
              };

            zone "0.0.127.in-addr.arpa" IN {
              type master;
              file "${bind_0_0_127_arpa}";
              };

            # Ad & site blocking
            # zone "youtube.com" { type master; file "dummy-block"; };

          ''
        }
      '';
    };
  };
}
