{ lib, inputs, pkgs, ... }:
let inherit (inputs) disko black-hosts;
in {
  imports = [
    disko.nixosModules.disko

    black-hosts.nixosModule

    (import ./disko.nix { }) # doesn't support btrfs swapfile

    ../../modules/boot/amd.nix
    ../../modules/hardware/amd.nix
    ../../modules/netwoking/router.nix

  ] ++ lib.fileset.toList ../../profiles ++ lib.fileset.toList ../../spaces;

  profiles.host.enable = true;
  profiles.common.enable = true;
  profiles.hosting.enable = true;
  # profiles.desk_streaming.enable = true;

  spaces.x.enable = true;
  spaces.hyodo.enable = true;

  _sshd.enable = true;
  _wolf.enable = true;

  environment.systemPackages = with pkgs; [
    ### Virtualization ###
    virtiofsd # needed by microvm jobs to use virtiofs shares
    (opensplat.overrideAttrs (finalAttrs: previousAttrs: {
      # buildInputs = previousAttrs.buildInputs
      #   ++ [ python311Packages.torchWithRocm ];
      cmakeFlags = previousAttrs.cmakeFlags ++ [
        (lib.cmakeFeature "GPU_RUNTIME" "HIP")
        # (lib.cmakeFeature "HIP_DIR" "/opt/rocm")
        (lib.cmakeFeature "HIP_ROOT_DIR" "/opt/rocm")
        (lib.cmakeFeature "OPENSPLAT_BUILD_SIMPLE_TRAINER" "ON")
      ];
    }))
    colmap
  ];
}
