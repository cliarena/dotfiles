{ pkgs, self, config, microvm, ... }:

let
  inherit (pkgs) lib;
  # inherit (time) second;
  second = 1000000000;
  user = "svr";
  repo = "test";
  vmName = "my-microvm";

  workDir = "/run/microvms/${user}/${repo}/${vmName}";
  microvm =
    self.nixosConfigurations.svr.config.microvm.vms.my-microvm.config.config.microvm;
  runner = microvm.declaredRunner;
  inherit (lib.last microvm.shares) tag source socket;
  inherit (lib.last microvm.interfaces) id;
  http = {
    mode = "bridge";
    reservedPorts.http = {
      static = 9999;
      to = 8080;
    };
  };
in {

  job.microvm = {
    datacenters = [ "dc1" ];
    type = "service";

    group.servers = {
      count = 1;
      restart = {
        attempts = 3;
        delay = 3 * second;
        mode = "fail";
        interval = 60 * second;
      };
      reschedule = {
        unlimited = true;
        delay = 90 * second;
      };
      networks = [ http ];
      services = [{
        name = "microvm";
        # WARN: Don't use named ports ie: port ="http". use literal ones
        port = "8080";
        connect = { sidecarService = { }; };
        # task = "hypervisor";
        # checks = [{
        # type = "http";
        # path = "/";
        # # protocol = "https";
        # # expose = true;
        # # tlsSkipVerify = true;
        # interval = 3 * second;
        # timeout = 2 * second;
        # }];
      }];
      # task."add-interface-${id}" = {
      # lifecycle = { hook = "prestart"; };
      # driver = "raw_exec";
      # user = "root";
      # config = { command = "local/add-interface-${id}.sh"; };
      # templates = [{
      # destination = "local/add-interface-${id}.sh";
      # perms = "755";
      # data = ''
      # #! /run/current-system/sw/bin/bash -e
      # ip tuntap add ${id} mode tap user microvm
      # ip link set ${id} up
      # '';
      # }];
      # };
      # task."delete-interface-${id}" = {
      # lifecycle = { hook = "poststop"; };
      # driver = "raw_exec";
      # user = "root";
      # config = { command = "local/delete-interface-${id}.sh"; };
      # templates = [{
      # destination = "local/delete-interface-${id}.sh";
      # perms = "755";
      # data = ''
      # #! /run/current-system/sw/bin/bash
      # IFACE="${id}"
      # ip link set "$IFACE" down
      # ip tuntap del "$IFACE" mode tap
      # '';
      # }];
      # };
      # task."virtiofsd-${tag}" = {
      # lifecycle = {
      # hook = "prestart";
      # sidecar = true;
      # };
      # driver = "raw_exec";
      # user = "root";
      # config = { command = "local/virtiofsd-${tag}.sh"; };
      # templates = [{
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
      # }];
      # killTimeout = 5 * second;
      # };

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

      task.volume-dirs = {
        driver = "raw_exec";
        lifecycle = { hook = "prestart"; };
        config = { command = "local/make-dirs.sh"; };
        templates = [{
          destination = "local/make-dirs.sh";
          perms = "755";
          data = ''
            #! /run/current-system/sw/bin/bash -e
            ${lib.concatMapStrings ({ image, ... }: ''
              mkdir -p "${dirOf image}"
              chown microvm:kvm "${dirOf image}"
            '') microvm.volumes}
          '';
        }];
      };

      # ${
      # lib.concatMapStrings (id:
      # with config.skyflake.deploy.rbds.${id}; ''
      # task."rbd-map-${id}" = {
      # driver = "raw_exec";
      # lifecycle ={
      # hook = "prestart";
      # };
      # config= {
      # command = "local/rbd-map.sh";
      # };
      # templates = [{
      # destination = "local/rbd-map.sh";
      # perms = "755";
      # data = ''
      # #! /run/current-system/sw/bin/bash -e
      # PATH="$PATH:/run/current-system/sw/bin"
      # SPEC="${pool}/${namespace}/${name}"
      # ${lib.optionalString autoCreate ''
      # if ! rbd info "$SPEC" >/dev/null 2>/dev/null; then
      # rbd namespace create "${pool}/${namespace}" || true
      # rbd create --size ${toString size}M "$SPEC"
      # TARGET=$(rbd map "$SPEC")
      # mkfs.${fsType} -L ${
      # builtins.substring 0 16 "${user}-${vmName}"
      # } "$TARGET"
      # rbd unmap "$TARGET"
      # fi
      # ''}
      # OLD_MAPS=$(rbd showmapped --format json | jq -r '.[] | select(.pool == "${pool}" and .namespace == "${namespace}" and .name == "${name}") | .device')
      # for OLD_TARGET in $OLD_MAPS; do
      # rbd unmap "$OLD_TARGET" || true
      # done
      # TARGET=$(rbd map --exclusive "$SPEC")
      # echo "Mapped $SPEC to $TARGET">&2
      # chown microvm "$TARGET"
      # cd ${workDir}
      # mkdir -p $(dirname "${path}")
      # ln -sf "$TARGET" "${path}"''
      # };
      # };
      # task "rbd-unmap-${id}" {
      # driver = "raw_exec"
      # lifecycle {
      # hook = "poststop"
      # }
      # config {
      # command = "local/rbd-unmap.sh"
      # }
      # template {
      # destination = "local/rbd-unmap.sh"
      # perms = "755"
      # data = <<EOD
      # #! /run/current-system/sw/bin/bash -e
      # PATH="$PATH:/run/current-system/sw/bin"
      # cd ${workDir}
      # rbd unmap $(readlink "${path}")
      # EOD
      # }
      # }
      # '') (builtins.attrNames config.skyflake.deploy.rbds)
      # }

      task.hypervisor = {
        driver = "raw_exec";
        user = "microvm";
        # user = "root";
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
        killSignal = "SIGCONT";
        # systemd timeout is at 90s by default
        killTimeout = 95 * second;

        # resources = {
        # memory = toString (config.microvm.mem + 8);
        # cpu = toString (config.microvm.vcpu * 50);
        # };
      };
    };
  };
}
