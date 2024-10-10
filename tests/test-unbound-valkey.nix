{ pkgs, ... }:
let
  testDomain = "nixos.org";
in
pkgs.nixosTest {
  name = "fast-unbound-valkey-test";
  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../modules/container.nix ];
    services.fast-unbound-container = {
      enable = true;
      valkeyDbPath = ./valkey.db;
      unboundConfigPath = ../assets/unbound.conf;
    };
    environment.systemPackages = with pkgs; [ dig ];
    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "ve-+" ];
    networking.nat.externalInterface = "eth0";
  };
  testScript = ''
    machine.wait_for_unit("container@fast-unbound.service")
    machine.wait_for_open_port(53) # Unbound
    machine.wait_for_open_port(6379) # Valkey

    # First query to populate the cache
    machine.succeed("dig @127.0.0.1 -p 53 +time=10 ${testDomain}")
  '';
}
