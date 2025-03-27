{ nix-nomad, ... }:
let
  jobs = nix-nomad.lib.mkNomadJobs {
    system = "x86_64-linux";
    # system = "aarch64-linux";
    config = [
      # ./nomoperator.nix
      # ./kasm.nix
      # # ./echoip_nix.nix
      # ./echo.nix
      # ./wolf_nix.nix
      # ./nginx.nix
      # ./nomad_proxy.nix
      # (import ./microvm.nix { inherit microvm self pkgs config; })
    ];
  };
in {
  # resource.nomad_job.nomoperator = {
  #   jobspec = ''''${file("${jobs}/nomoperator.json")}'';
  #   json = true;
  # };
}
