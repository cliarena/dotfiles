{ lib, inputs, pkgs, ... }:
let
  # FIXME: this
  useMpi = false;
  pythonInterp = (pkgs.python312.override {
    #inherit libffi;
    #stdenv = rocmPackages.llvm.rocmClangStdenv;
    enableOptimizations = true;
    reproducibleBuild = false;
    self = pythonInterp;
  }).overrideAttrs (old: {
    enableParallelBuilding = true;
    requiredSystemFeatures = (old.requiredSystemFeatures or [ ])
      ++ [ "big-parallel" ];
    dontStrip = true;
    separateDebugInfo = false;
    disallowedReferences = [ ]; # debug info does point to openssl and that's ok
    configureFlags = old.configureFlags ++ [
      "--disable-safety"
      "--with-lto"
    ]; # [ "--with-undefined-behavior-sanitizer" ];
    hardeningDisable = [ "all" ];
    # env.LDFLAGS = "-fsanitize=undefined";
    # env.CFLAGS = "-fsanitize=undefined -shared-libsan -frtti -frtti-data";
    # env.CXXFLAGS = "-fsanitize=undefined -shared-libsan -frtti -frtti-data";
    #env.NIX_CFLAGS_COMPILE = "-fsanitize=undefined -w -march=znver1 -mtune=znver1";
    env = old.env // {
      CFLAGS =
        "-O3 -DNDEBUG -g1 -gz -fno-omit-frame-pointer -momit-leaf-frame-pointer";
      CXXFLAGS =
        "-O3 -DNDEBUG -g1 -gz -fno-omit-frame-pointer -momit-leaf-frame-pointer";
    };
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DCMAKE_BUILD_TYPE=Release" ];
  });
  pythonPkgsOverridenInterp = pkgs.python312.override {
    packageOverrides = ps: prev: {
      #stdenv = rocmPackages.llvm.rocmClangStdenv;
      # pycparser = prev.pycparser.overridePythonAttrs (old: {
      #     doCheck = false;
      # });
      # websockets = prev.websockets.overridePythonAttrs (old: {
      #     doCheck = false;
      # });
      # meson = prev.meson.overridePythonAttrs (old: {
      #     doCheck = false;
      # });
      torch = ((prev.torch.override {
        stdenv = rocmPackages.llvm.rocmClangStdenv;
        #cudaSupport = true;
        rocmSupport = true;
        rocmPackages_5 = pkgs.rocmPackages;
        cudaSupport = false;
        useSystemNccl = true;
        #gpuTargets = ["8.9" "8.9+PTX"];
        MPISupport = false;
        effectiveMagma = pkgs.emptyDirectory;
        inherit (pkgs.rocmPackages) triton;
      }).overridePythonAttrs (oldPyAttrs: rec {
        PYTORCH_BUILD_VERSION = "2.6.0a";
        PYTORCH_BUILD_DATE = "20241203";
        # PYTORCH_BUILD_DATE = "20241218";
        PYTORCH_BUILD_NUMBER = PYTORCH_BUILD_DATE;
        version = "${PYTORCH_BUILD_VERSION}-nightly-${PYTORCH_BUILD_DATE}";
        src = oldPyAttrs.src.override {
          owner = "pytorch";
          repo = "pytorch";
          rev = "7851460668d6df096884697c5a750d75b0c35ea2"; # 20241203
          hash = "sha256-pizc2Q/IXclkrfRDu8IEbPP34yiGJlZZ9xQof3jeIDY=";
          # rev = "9f9823e3d2e1c510aa934fa556ba3be658a4c34c"; # 20241215
          # hash = "sha256-+oL4d4Lzhss8BwW87hs6MlA9DB8WZ4pF/3uDLoIoYuI=";
          # rev = "5764ca46ed7c5b7518bacfd19c70eebaf479df44"; # 20241217
          # hash = "sha256-eSSKSXTiO5QjmRULWPTNQ+FgM5ilRK87sbcROgQIeWY=";
          # rev = "2ea4b56ec872424e486c4fe2d55da061067a2ed3"; # 20241218
          # hash = "sha256-q8uCuhkfGu8Dr73DUBMbvy/v4+UKHehzhVpB2cih7is=";
          fetchSubmodules = true;
        };
        pythonImportsCheck = [ ];
        patches = (oldPyAttrs.patches or [ ]) ++ [
          ./pytorch_flex_attention_reenter_make_fx_fix.patch
          ./pytorch-cache-compile-failures-20241203-bc-cache-alt-tcache.diff
        ];
      })).overrideAttrs (old: {
        # env.USE_CK_FLASH_ATTENTION = 1;
        env.USE_FLASH_ATTENTION = 1;
        enableParallelBuilding = true;
        nativeBuildInputs = old.nativeBuildInputs
          ++ [ pkgs.ninja pkgs.pkg-config ];
        buildInputs = old.buildInputs ++ [
          ps.six
          pkgs.openssl
          pkgs.rocmPackages.aotriton
          pkgs.rocmPackages.hiprand
          pkgs.rocmPackages.hipblaslt
          pkgs.rocmPackages.hipblas-common
          pkgs.rocmPackages.ck4inductor
          pkgs.amd-blis
          # pkgs.mpich # FIXME: doesn't support GPU buffers
        ];
        # env.MPI_HOME = pkgs.mpich;
        cmakeFlags = [
          "-DAOTRITON_INSTALL_PREFIX=${pkgs.rocmPackages.aotriton}"
          "-DAOTRITON_INSTALLED_PREFIX=${pkgs.rocmPackages.aotriton}"
          "-DPYTHON_SIX_SOURCE_DIR=${ps.six.src}"
          # "-DUSE_MPI=ON"
          "-DUSE_MAGMA=OFF"
          "-Wno-dev"
          "-DCMAKE_SUPPRESS_DEVELOPER_WARNINGS=ON"
          "-DCMAKE_VERBOSE_MAKEFILE=ON"
        ];
        # --replace-fail "-O2" "-O3 -DNDEBUG" \
        postPatch = old.postPatch + ''
          substituteInPlace CMakeLists.txt cmake/public/utils.cmake \
            --replace-fail " -Wall" "" \
            --replace-fail " -Wextra" "" \
            --replace-fail " -Werror" ""
          substituteInPlace third_party/fbgemm/CMakeLists.txt \
            --replace-fail " -Wall" "" \
            --replace-fail " -Wextra" "" \
            --replace-fail " -Werror" ""
          echo HACK: removing third_party/composable_kernel and using system version, disabling submodule check
          # FIXME: we do not actually rely on the composable_kernel build other than it making config.h exist
          # could reduce how slow pytorch deps are to build by creating config.h alone
          rm -rf third_party/composable_kernel/
          ln -s ${rocmPackages.composable_kernel}/ third_party/composable_kernel
          substituteInPlace setup.py \
            --replace-fail 'getenv("USE_SYSTEM_LIBS", False)' 'getenv("USE_SYSTEM_LIBS", True)'
          echo HACK: enabling gfx908 for hipblaslt backends
          substituteInPlace aten/src/ATen/Context.cpp \
            --replace-fail '"gfx90a", "gfx940"' '"gfx908", "gfx90a", "gfx940"'
          # echo HACK: enabling gfx908 for CK flash attention backend
          # substituteInPlace aten/src/ATen/Context.cpp \
          #   --replace-fail '"gfx90a",  "gfx942"' '"gfx908", "gfx90a", "gfx942"'
          substituteInPlace aten/src/ATen/native/cuda/Blas.cpp \
            --replace-fail '"gfx90a", "gfx940"' '"gfx908", "gfx90a", "gfx940"'
          substituteInPlace "torch/_inductor/utils.py" \
            --replace-fail 'log.warning("Invalid path to CK library")' \
            'log.warning(f"Invalid path to CK library {ck_package_dirname} != {config.rocm.ck_dir}")'
          echo HACK: enabling gfx908 for inductor CK backend
          substituteInPlace torch/_inductor/config.py \
            --replace-fail '["gfx90a"' '["gfx908", "gfx90a"'
          echo HACK: making sure DNDEBUG is set when compiling ck kernels
          substituteInPlace torch/_inductor/codegen/rocm/compile_command.py \
            --replace-fail '"-enable-post-misched=0",' '"-enable-post-misched=0", "-DNDEBUG", "-DCK_TILE_FMHA_FWD_FAST_EXP2=1",'
          substituteInPlace third_party/NNPACK/CMakeLists.txt --replace "PYTHONPATH=" 'PYTHONPATH=$ENV{PYTHONPATH}:'
          sed -i '2s;^;set(PYTHON_SIX_SOURCE_DIR ${ps.six.src})\n;' third_party/NNPACK/CMakeLists.txt
          sed -i '2s;^;set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ON CACHE INTERNAL "" FORCE)\n;' CMakeLists.txt

          CORE_LIM=$(( ''${NIX_LOAD_LIMIT:-''${CORE_LIM:-$(nproc)}} / 2 ))
          # Set HIPCC_JOBS with min and max constraints
          export CMAKE_BUILD_PARALLEL_LEVEL="$CORE_LIM"
          export HIPCC_JOBS=$(( CORE_LIM < 1 ? 1 : (CORE_LIM > 12 ? 12 : CORE_LIM) ))
          export HIPCC_JOBS_LINK=$(( CORE_LIM < 1 ? 1 : (CORE_LIM > 6 ? 6 : CORE_LIM) ))
          export HIPCC_COMPILE_FLAGS_APPEND="-O3 -Wno-format-nonliteral -parallel-jobs=$HIPCC_JOBS"
          export HIPCC_LINK_FLAGS_APPEND="-O3 -parallel-jobs=$HIPCC_JOBS_LINK"
          ${lib.optionalString useMpi ''
            substituteInPlace cmake/Dependencies.cmake \
              --replace-fail 'find_package(MPI)' 'find_package(MPI)'
          ''}
        '';
        #           echo HACK: always allow CK
        # substituteInPlace "torch/_inductor/utils.py" \
        #   --replace-fail 'def use_ck_template(layout):' 'def use_ck_template(layout):
        #     return layout.dtype in [torch.float16, torch.bfloat16, torch.float32]'

        preConfigure = let cflags = "-w -g1 -gz";
        in old.preConfigure + ''
          export PYTORCH_ROCM_ARCH="gfx908;gfx90a"
          export CFLAGS="$cflags"
          export CXXFLAGS="$cflags"
          export CMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS ${cflags}"
          export NINJA_SUMMARIZE_BUILD=1
          export NINJA_STATUS="[%r jobs | %P %f/%t @ %o/s | %w | ETA %W ] "
        '';
        #         echo "Setting LD_PRELOAD"
        # set -x
        # export LD_PRELOAD="${rocmPackages.clr}/llvm/lib/linux/libclang_rt.asan-x86_64.so"
        # echo "LD_PRELOAD set to $LD_PRELOAD"
        dontStrip = true;
        #env.ASAN_OPTIONS = "verbosity=1:debug=1:symbolize=1:print_stats=1:start_deactivated=true";
        # env.ASAN_OPTIONS = "symbolize=1:start_deactivated=true";
        # env.ASAN_SYMBOLIZER_PATH = "${rocmPackages.clr}/llvm/bin/llvm-symbolizer";
        env.CC = "hipcc";
        env.CXX = "hipcc";
        env.LD = "lld";
        USE_NNPACK = 1;
        env.USE_NINJA = 1;
        # env.USE_MPI = 0;
        env.CMAKE_GENERATOR = "Ninja";
        env.PYTHON_SIX_SOURCE_DIR = ps.six.src;
        env.AOTRITON_INSTALLED_PREFIX = "${pkgs.rocmPackages.aotriton}";
      });
    };
  };
  pythonPkgs = pythonPkgsOverridenInterp.pkgs // {
    python = pythonInterp;
    python3 = pythonInterp;
  };
  inherit (pkgs) rocmPackages;

  rocm-hip-libraries = pkgs.symlinkJoin {
    name = "rocm-hip-libraries-meta";

    paths = with rocmPackages; [
      rocblas
      hipfort
      rocm-core
      rocsolver
      rocalution
      rocrand
      hipblas
      # hipblaslt
      rocfft
      hipfft
      rccl
      rocsparse
      hipsparse
      hipsolver
      composable_kernel
      # ck4inductor
      rocm-device-libs

      rocm-core
      rocminfo
      clr

      rocm-runtime
      rocm-core
      rocm-comgr
      llvm.clang
      llvm.openmp
    ];
  };
  shellPkgs = [
    pythonPkgs.python
    pythonPkgs.torch
    pythonPkgs.pip
    # pythonPkgs.torchvision
    # pythonPkgs.torchmetrics
    # pythonPkgs.pytorch-lightning
    pythonPkgs.huggingface-hub
    pkgs.rocmPackages.rocm-smi
    pkgs.rocmPackages.llvm.lld
    pkgs.rocmPackages.llvm.rocm-merged-llvm
    pkgs.rocmPackages.clr
    pkgs.cmake
    pkgs.pkg-config
    rocmPackages.composable_kernel
  ];
  shell-deps = pkgs.symlinkJoin {
    name = "shell-deps";
    paths = shellPkgs ++ [ rocm-hip-libraries ];
  };
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

  _sshd.enable = true;
  _wolf.enable = true;

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm   -    -    -     -    ${rocm_toolkit}" ];

  environment.systemPackages = with pkgs; [
    ### Virtualization ###
    virtiofsd # needed by microvm jobs to use virtiofs shares

    (opensplat.overrideAttrs (finalAttrs: previousAttrs: {
      # env.PYTORCH_ROCM_ARCH =
      # "gfx900;gfx906;gfx908;gfx90a;gfx1030;gfx1100;gfx1101;gfx940;gfx941;gfx942";

      buildInputs = previousAttrs.buildInputs ++ [ rocm-hip-libraries ];
      nativeBuildInputs = previousAttrs.nativeBuildInputs
        ++ [ rocm-hip-libraries ];
      # ++ (with pkgs.rocmPackages; [ rocblas hipblas clr ]);
      # [ python311Packages.torchWithRocm ];

      preConfigure = ''
        export ROCM_PATH=${rocm-hip-libraries}
        export ROCM_HOME=${rocm-hip-libraries}
        export ROCM_SOURCE_DIR=${rocm-hip-libraries}
        export PYTORCH_ROCM_ARCH="${gpuTargetString}"
        # export CMAKE_CXX_FLAGS="-I${rocm_toolkit}/include -I${rocm_toolkit}/include/rocblas"
        # export LD_LIBRARY_PATH="${rocm_toolkit}/include/hip/"
      '';
      # dontUseCmakeConfigure = true;

      cmakeFlags = previousAttrs.cmakeFlags ++ [
        (lib.cmakeFeature "GPU_RUNTIME" "HIP")
        # (lib.cmakeFeature "HIP_DIR" "/opt/rocm")
        # (lib.cmakeFeature "HIP_PATH" "${rocmEnv}")
        (lib.cmakeFeature "HIP_ROOT_DIR" "${rocm-hip-libraries}")
        (lib.cmakeFeature "OPENSPLAT_BUILD_SIMPLE_TRAINER" "ON")
        # (lib.cmakeFeature "CMAKE_MODULE_PATH" "/opt/rocm/lib/cmake/hip")
        # (lib.cmakeFeature "CMAKE_MODULE_PATH" "${rocmEnv}/lib/cmake/hip")
        # (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${rocm_toolkit}/lib/cmake")
        # (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${pkgs.libtorch-bin}")
        # (lib.cmakeFeature "CMAKE_HIP_COMPILER_ROCM_ROOT" "${rocmEnv}")
        # (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmEnv}/lib/cmake/hip")
        # (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmEnv}/bin")
        # TODO: auto-detect
        # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "${gpuTargetString}")
        # (lib.cmakeFeature "ROCM_PATH" "${rocm_toolkit}")
        # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "gfx1032;gfx90c:xnack-")
        # (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "gfx000;gfx1032;gfx90c")
        # "gfx900;gfx906;gfx908;gfx90a;gfx1030;gfx1100;gfx1101;gfx940;gfx941;gfx942")

      ];
    }))

    colmap
  ];
  nix.settings.extra-sandbox-paths = [
    "/dev/kfd"
    "/sys/devices/virtual/kfd"
    "/dev/dri/renderD128"
    "/dev/dri/renderD129"
  ];

}
