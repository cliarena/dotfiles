{ pkgs, self, config, microvm, ... }:

let
  inherit (pkgs) lib;
  user = "svr";
  repo = "test";
  vmName = "my-microvm";

  workDir = "/home/svr/microvms/${user}/${repo}/${vmName}";

  runner =
    self.nixosConfigurations.svr.config.microvm.vms.my-microvm.config.config.microvm.declaredRunner;
in {

  job.microvm = {
    datacenters = [ "dc1" ];
    type = "service";

    group.servers = {
      count = 1;

      # task.virtiofsd-${tag}= {
      # lifecycle ={
      # hook = "prestart";
      # sidecar = true;
      # };
      # driver = "raw_exec";
      # user = "root";
      # config ={
      # command = "local/virtiofsd-${tag}.sh";
      # };
      # template = [{
      # destination = "local/virtiofsd-${tag}.sh";
      # perms = "755";
      # data = ''
      # #! /run/current-system/sw/bin/bash -e
      # mkdir -p ${workDir}
      # chown microvm:kvm ${workDir}
      # cd ${workDir}
      # mkdir -p ${source}
      # exec /run/current-system/sw/bin/virtiofsd \
      # --socket-path=${socket} \
      # --socket-group=kvm \
      # --shared-dir=${source} \
      # --sandbox=none \
      # --thread-pool-size `nproc` \
      # --cache=always
      # '';
      # kill_timeout = "5s";
      # }];};

      task.copy_system = {
        driver = "raw_exec";
        lifecycle = { hook = "prestart"; };
        config = { command = "local/copy-system.sh"; };
        templates = [{
          destination = "local/copy-system.sh";
          perms = "755";
          data = ''
            #! /run/current-system/sw/bin/bash -e

            if ! [ -e ${runner} ] ; then
              /run/current-system/sw/bin/nix copy --from file://@binaryCachePath@?trusted=1 --no-check-sigs ${runner}
            fi
          '';
        }];
      };

      task.hypervisor = {
        driver = "raw_exec";
        user = "microvm";
        config = { command = "local/hypervisor.sh"; };
        templates = [{
          destination = "local/hypervisor.sh";
          perms = "755";
          data = ''
            #! /run/current-system/sw/bin/bash -e

            mkdir -p ${workDir}
            cd ${workDir}

            # start hypervisor
            ${runner}/bin/microvm-run &

            # stop hypervisor on signal
            function handle_signal() {
              echo "Received signal, shutting down" >&2
              date >&2
              ${runner}/bin/microvm-shutdown
              echo "Done" >&2
              date >&2
              exit
            }
            trap handle_signal CONT
            wait
          '';
        }];

        leader = true;
        # don't get killed immediately but get shutdown by wait-shutdown
        # kill_signal = "SIGCONT";
        # systemd timeout is at 90s by default
        # kill_timeout = "95s";

        # resources = {
        # memory = toString (config.microvm.mem + 8);
        # cpu = toString (config.microvm.vcpu * 50);
        # };
      };
    };
  };

}
# in pkgs.stdenv.mkDerivation rec {
# pname = "${user}-${repo}-${vmName}";
# inherit (config.system.nixos) version;
# src = jobFile;
# NAME = "${pname}.job";
# phases = [ "buildPhase" "checkPhase" "installPhase" ];
# buildInputs = lib.optionals (pkgs ? hclfmt) [ pkgs.hclfmt ];
# buildPhase = if pkgs ? hclfmt then ''
# hclfmt < $src > $NAME
# '' else ''
# cp $src $NAME
# '';
# checkInputs = with pkgs; [ nomad ];
# checkPhase = ''
# nomad job validate $NAME
# '';
# installPhase = ''
# cp $NAME $out
# '';
# }
