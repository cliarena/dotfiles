
{ pkgs, ... }:
{
  services.surrealdb = {
    enable = true;
    dbPath = "file:///srv/surrealdb/";
    };
}
