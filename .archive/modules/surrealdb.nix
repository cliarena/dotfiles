{pkgs, ...}: {
  services.surrealdb = {
    enable = true;
    dbPath = "memory";
    # dbPath = "file:///srv/surrealdb/";
  };
}
