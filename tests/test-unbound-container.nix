{ pkgs, ... }:
pkgs.nixosTest {
  name = "unbound-valkey-container-test";
  nodes.machine = { config, pkgs, ... }: {
    imports = [ ../modules/container.nix ];
    services.unbound-valkey-container = {
      enable = true;
      unboundConfigPath = "../assets/unbound.conf";
      valkeyDbPath = "./valkey";
    };
  };
  testScript = ''
    machine.wait_for_unit("container@unbound-valkey.service")
    machine.succeed("dig @localhost example.com")
  '';
}
