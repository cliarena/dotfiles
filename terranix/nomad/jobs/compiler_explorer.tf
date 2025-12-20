job "compiler_explorer" {

  datacenters = [
    "dc1"
  ]
  type = "service"

  group "server" {
    count = 1
    network {
      port "http" {
        static = 10240
      }
    }

    task "server" {
      driver = "podman"
      config {
        ports      = ["http"]
        image = "madduci/docker-compiler-explorer:latest"
        volumes = [
          "/nix/store:/nix/store:ro", # to run nixos pkgs
          "/run/current-system/sw/bin/zig:/usr/bin/zig", # to access zig pkg
        ]
      }
    }
  }
}
