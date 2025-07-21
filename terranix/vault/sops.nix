{
  config,
  x,
  ...
}: let
  inherit (x.time) minute hour day year;
in {
  resource.vault_mount.sops = {
    path = "sops";
    type = "transit";
    description = "Secrets OPerationS";
    # default_lease_ttl_seconds = 3600;
    # max_lease_ttl_seconds = 86400;
  };

  resource.vault_transit_secret_backend_key.sops = {
    depends_on = ["vault_mount.sops"];
    backend = config.resource.vault_mount.sops.path;
    name = "main";
    deletion_allowed = true;
    exportable = true;
    auto_rotate_period = 1 * day;
  };
}
