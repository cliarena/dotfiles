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
          "/nix/store:/nix/store", # to run nixos pkgs
          "/run/current-system/sw/bin/:/usr/local/bin/", # to access zig pkg
        ]
      }
    }
  }
}
