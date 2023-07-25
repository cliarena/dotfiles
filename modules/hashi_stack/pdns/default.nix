{ inputs, host, ... }:
let
  inherit (inputs) self;
  bind_m7an-zone = import ./bind_m7an-zone.nix { inherit self host; };
  bind_cliarena-zone = import ./bind_cliarena-zone.nix { inherit self host; };
  bind_0_0_127_arpa = import ./reverse/bind_0_0_127_arpa.nix self;
in {
  services.pdns-recursor = {
    enable = true;

    forwardZones = {
      consul = "127.0.0.1:8600";
      # "m7an.com" = "127.0.0.1:5353";
      "cliarena.com" = "127.0.0.1:5353";

      "0.0.127.in-addr.arpa" = "127.0.0.1:5353";
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
          #  zone "m7an.com" IN {
          #    type master;
          #  file "${bind_m7an-zone}";
          #    };

          zone "cliarena.com" IN {
            type master;
           file "${bind_cliarena-zone}";
            };

          zone "0.0.127.in-addr.arpa" IN {
            type master;
            file "${bind_0_0_127_arpa}";
            };
        ''
      }
    '';
  };
}
