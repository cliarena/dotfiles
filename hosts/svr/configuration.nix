{ lib, inputs, pkgs, ... }:
let
  inherit (inputs) disko black-hosts;
  # gpuTargetString = lib.strings.concatStringsSep ";" (if gpuTargets != [ ] then
  # # If gpuTargets is specified, it always takes priority.
  #   gpuTargets
  # else if cudaSupport then
  #   gpuArchWarner supportedCudaCapabilities unsupportedCudaCapabilities
  # else if rocmSupport then
  #   rocmPackages.clr.gpuTargets
  # else
  #   throw "No GPU targets specified");
  gpuTargetString =
    lib.strings.concatStringsSep ";" pkgs.rocmPackages.clr.gpuTargets;
  rocm_pkgs = with pkgs.rocmPackages; [
    rocblas
    hipblas
    clr
    hipcc
    rocm-device-libs
    rocm-comgr

    # TODO: remove unneeded
    rocm-core
    rocm-cmake
    rocm-runtime
    rocminfo
    hip-common
    hipify
    llvm.llvm
    llvm.compiler-rt
    llvm.clang
    llvm.clang-unwrapped
    llvm.libunwind
    llvm.libcxxabi
    llvm.libcxx
    llvm.rocmClangStdenv

    pkgs.libtorch-bin

    pkgs.llvmPackages_17.libllvm
    pkgs.llvmPackages_17.clangUseLLVM
    clang-ocl

    rccl
    # miopen
    rocrand
    rocsparse
    hipsparse
    rocthrust
    rocprim
    hipcub
    roctracer
    rocfft
    rocsolver
    hipfft
    hipsolver
    rocm-thunk
    clr.icd
  ];
  rocm_toolkit = pkgs.symlinkJoin {
    name = "rocm-combined";
    paths = rocm_pkgs;
    # Fix `setuptools` not being found
    postBuild = "rm -rf $out/nix-support";
  };
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

  programs.steam.enable = true;
  _sshd.enable = true;
  _wolf.enable = false;
  _wolf_pulse_audio.enable = true;

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm   -    -    -     -    ${rocm_toolkit}" ];

  environment.systemPackages = with pkgs;
    [
      ### Virtualization ###
      virtiofsd # needed by microvm jobs to use virtiofs shares

      # (opensplat.overrideAttrs (finalAttrs: previousAttrs: {
      #   # env.PYTORCH_ROCM_ARCH =
      #   # "gfx900;gfx906;gfx908;gfx90a;gfx1030;gfx1100;gfx1101;gfx940;gfx941;gfx942";
      #   # stdenv = pkgs.llvmPackages.stdenv;
      #
      #   buildInputs = previousAttrs.buildInputs ++ [ rocm_toolkit ];
      #   nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ rocm_toolkit ];
      #   # ++ (with pkgs.rocmPackages; [ rocblas hipblas clr ]);
      #   # [ python311Packages.torchWithRocm ];
      #
      #   preConfigure = ''
      #     export ROCM_PATH=${rocm_toolkit}
      #     export ROCM_HOME=${rocm_toolkit}
      #     export ROCM_SOURCE_DIR=${rocm_toolkit}
      #     export PYTORCH_ROCM_ARCH="${gpuTargetString}"
      #     export CMAKE_CXX_FLAGS="-I${rocm_toolkit}/include -I${rocm_toolkit}/include/rocblas"
      #     export LD_LIBRARY_PATH="${rocm_toolkit}/include/hip/"
      #     export CMAKE_PREFIX_PATH="${pkgs.libtorch-bin}"
      #   '';
      #   # dontUseCmakeConfigure = true;
      #
      #   cmakeFlags = previousAttrs.cmakeFlags ++ [
      #     (lib.cmakeFeature "GPU_RUNTIME" "HIP")
      #     # (lib.cmakeFeature "HIP_DIR" "/opt/rocm")
      #     # (lib.cmakeFeature "HIP_PATH" "${rocmEnv}")
      #     (lib.cmakeFeature "HIP_ROOT_DIR" "${rocm_toolkit}")
      #     (lib.cmakeFeature "OPENSPLAT_BUILD_SIMPLE_TRAINER" "ON")
      #     # (lib.cmakeFeature "CMAKE_MODULE_PATH" "/opt/rocm/lib/cmake/hip")
      #     # (lib.cmakeFeature "CMAKE_MODULE_PATH" "${rocmEnv}/lib/cmake/hip")
      #     # (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${rocm_toolkit}/lib/cmake")
      #     # (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${pkgs.libtorch-bin}")
      #     # (lib.cmakeFeature "CMAKE_HIP_COMPILER_ROCM_ROOT" "${rocmEnv}")
      #     # (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmEnv}/lib/cmake/hip")
      #     # (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmEnv}/bin")
      #     # TODO: auto-detect
      #     # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "${gpuTargetString}")
      #     # (lib.cmakeFeature "ROCM_PATH" "${rocm_toolkit}")
      #     # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "gfx1032;gfx90c:xnack-")
      #     # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "gfx000;gfx1032;gfx90c")
      #     # "gfx900;gfx906;gfx908;gfx90a;gfx1030;gfx1100;gfx1101;gfx940;gfx941;gfx942")
      #
      #   ];
      # }))
    ];
  nix.settings.extra-sandbox-paths = [
    "/dev/kfd"
    "/sys/devices/virtual/kfd"
    "/dev/dri/renderD128"
    "/dev/dri/renderD129"
  ];

}
