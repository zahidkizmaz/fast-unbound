{ pkgs, ... }:
{
  services.redis = {
    package = pkgs.valkey;
    servers."unbound-cache" = {
      enable = true;
      port = 6379;
      settings = {
        maxmemory = "500mb";
        maxmemory-policy = "allkeys-lru";
      };
    };
  };
}
