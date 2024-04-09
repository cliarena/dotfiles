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
      static = 8080;
      to = 8080;
    };
    reservedPorts.iperf = {
      static = 8081;
      to = 8081;
    };
    reservedPorts.ssh = {
      static = 22;
      to = 22;
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
        # connect = { sidecarService = { }; };
        # address = "192.168.249.1";
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
      # # ip tuntap add ${id} mode tap user microvm
      # # ip link set ${id} up
      # IFACE="${id}"
      # if [ -d /sys/class/net/"$IFACE" ]; then
      # echo "WARNING: Removing stale tap interface "$IFACE"" >&2
      # ip tuntap del "$IFACE" mode tap || true
      # fi
      # ip tuntap add "$IFACE" mode tap user microvm
      # ip link set "$IFACE" up
      # # tc qdisc add dev eth0 ingress
      # # tc filter add dev eth0 parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev microvm-tap
      # # tc qdisc add dev microvm-tap ingress
      # # tc filter add dev microvm-tap parent ffff: protocol all u32 match u8 0 0 action mirred egress redirect dev eth0
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
      # # ip link set "$IFACE" down
      # # ip tuntap del "$IFACE" mode tap
      # IFACE="${id}"
      # if [ -d /sys/class/net/"$IFACE" ]; then
      # echo "WARNING: Removing stale tap interface "$IFACE"" >&2
      # ip tuntap del "$IFACE" mode tap || true
      # fi
      # ip tuntap add "$IFACE" mode tap user microvm
      # ip link set "$IFACE" up
      # '';
      # }];
      # };
      task."virtiofsd-${tag}" = {
        # must add virtiofsd to host for this task to find it
        lifecycle = {
          hook = "prestart";
          sidecar = true;
        };
        driver = "raw_exec";
        user = "root";
        config = { command = "local/virtiofsd-${tag}.sh"; };
        templates = [{
          destination = "local/virtiofsd-${tag}.sh";
          perms = "755";
          data = ''
            #! /run/current-system/sw/bin/bash -e
            mkdir -p ${workDir}
            chown microvm:kvm ${workDir}
            cd ${workDir}
            mkdir -p ${source}
            exec /run/current-system/sw/bin/virtiofsd \
            --socket-path=${socket} \
            --socket-group=kvm \
            --shared-dir=${source} \
            --sandbox=none \
            --thread-pool-size `nproc` \
            --cache=always
          '';
        }];
        killTimeout = 5 * second;
      };

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

      task.hypervisor = {
        driver = "raw_exec";
        # user = "microvm";
        user = "root";
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
            # e2:f5:78:c9:82:3d
            # ip a >&2
            # ${pkgs.toybox}/bin/netstat -nlp >&2
            # ${pkgs.nmap}/bin/nping --tcp --ttl 255 -p 8080 192.168.246.1 >&2
            # ${pkgs.nmap}/bin/nping --tcp --ttl 255 -p 8081 192.168.246.1 >&2
            # ${pkgs.nmap}/bin/nping --tcp --ttl 255 -p 8088 192.168.246.1 >&2
            # ${pkgs.curl}/bin/curl 192.168.246.1:8080 >&2

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
