job "image_importer" {

  datacenters = [
    "dc1"
  ]
  type = "batch"

  periodic {
    cron = "@daily"
    prohibit_overlap = true

  }
  group "backend" {

    count = 1


    task "main" {
      driver = "raw_exec"

      resources {
        cpu    = 18000
       # cores = 6
        memory = 4096
        memory_max = 16348
      }

      config {
        command = "/run/current-system/sw/bin/nu"
#        args = [ "import", "http://10.10.0.10:9999/job/nixos/main/x86_64-linux.dev/latest/download/nixos-system-x86_64-linux.tar.xz", "nixos" ]
        args = [ "-c", "/run/current-system/sw/bin/wget http://10.10.0.10:9999/job/nixos/main/x86_64-linux.dev/latest/download/nixos-system-x86_64-linux.tar.xz; /run/current-system/sw/bin/unxz -T 4 nixos-system-x86_64-linux.tar.xz; /run/current-system/sw/bin/ls; /run/current-system/sw/bin/sudo /run/current-system/sw/bin/podman import nixos-system-x86_64-linux.tar nixos; /run/current-system/sw/bin/rm -f nixos-system-x86_64-linux.tar nixos-system-x86_64-linux.tar.xz" ]
      }

  }
}
