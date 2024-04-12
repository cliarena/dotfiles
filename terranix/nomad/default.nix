{ nix-nomad, self, microvm, pkgs, config, ... }:
let
  jobs = nix-nomad.lib.mkNomadJobs {
    system = "x86_64-linux";
    # system = "aarch64-linux";
    config = [
      ./kasm.nix
      ./echoip_nix.nix
      ./echo.nix
      ./wolf.nix
      (import ./microvm.nix { inherit microvm self pkgs config; })
    ];
  };
in {
  resource.nomad_job.wolf = {
    jobspec = ''''${file("${jobs}/wolf.json")}'';
    json = true;
  };
  resource.nomad_job.nginx = {
    jobspec = ''''${file("${jobs}/nginx.json")}'';
    json = true;
  };
  resource.nomad_job.echo = {
    jobspec = ''''${file("${jobs}/echo.json")}'';
    json = true;
  };
  resource.nomad_job.microvm = {
    jobspec = ''''${file("${jobs}/microvm.json")}'';
    json = true;
  };
  # data.vault_kv_secret.test = { path = "kv/test"; };
}
