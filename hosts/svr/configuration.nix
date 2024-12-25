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
      env.PYTORCH_ROCM_ARCH =
        "gfx900;gfx906;gfx908;gfx90a;gfx1030;gfx1100;gfx1101;gfx940;gfx941;gfx942";
      buildInputs = previousAttrs.buildInputs
        ++ (with pkgs.rocmPackages; [ rocblas hipblas clr ]);
      # [ python311Packages.torchWithRocm ];
      cmakeFlags = previousAttrs.cmakeFlags ++ [
        (lib.cmakeFeature "GPU_RUNTIME" "HIP")
        # (lib.cmakeFeature "HIP_DIR" "/opt/rocm")
        # (lib.cmakeFeature "HIP_ROOT_DIR" "${rocmPackages.clr}")
        # (lib.cmakeFeature "CMAKE_MODULE_PATH" "/opt/rocm/lib/cmake/hip")
        # (lib.cmakeFeature "CMAKE_MODULE_PATH"
        #   "${rocmPackages.clr}/lib/cmake/hip")
        (lib.cmakeFeature "OPENSPLAT_BUILD_SIMPLE_TRAINER" "ON")
      ];
    }))
    colmap
  ];
}
