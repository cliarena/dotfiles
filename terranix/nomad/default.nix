{ nix-nomad, ... }:
let
  jobs = nix-nomad.lib.mkNomadJobs {
    system = "x86_64-linux";
    # system = "aarch64-linux";
    config = [ ./nginx.nix ];
  };
in {
  # resource.nomad_job.nginx = {
  # jobspec = ''''${file("${jobs}/nginx.json")}'';
  # json = true;
  # };
  # data.vault_kv_secret.test = { path = "kv/test"; };
}
