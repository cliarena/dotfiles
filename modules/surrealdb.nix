
{ pkgs, ... }:
{
  services.surrealdb = {
    enable = true;
    dbPath = "file:///svr/surrealdb/";
    };
}
