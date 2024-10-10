{ config, lib, ... }:

with lib;
let
  cfg = config.services.fast-unbound-container;
in
{
  imports = [
    ./unbound.nix
    ./valkey.nix
  ];

  options.services.fast-unbound-container = {
    enable = mkEnableOption "Fast Unbound and Valkey container";
    unboundConfigPath = mkOption {
      type = types.path;
      default = ../assets/unbound.conf;
      description = "Path to the Unbound configuration file";
    };
    valkeyDbPath = mkOption {
      type = types.path;
      default = ../assets/valkey;
      description = "Path to store Valkey database";
    };
    containerName = mkOption {
      type = types.str;
      default = "fast-unbound";
      description = "Name of the container";
    };
  };

  config = mkIf cfg.enable {
    containers."${cfg.containerName}" = {
      autoStart = true;
      ephemeral = true;
      bindMounts = {
        "/etc/unbound/unbound.conf" = {
          hostPath = "${cfg.unboundConfigPath}";
          isReadOnly = true;
        };
        "/var/lib/valkey" = {
          hostPath = "${cfg.valkeyDbPath}";
          isReadOnly = false;
        };
      };
      config = { config, ... }: {
        networking.firewall = {
          allowedTCPPorts = [ 53 6379 ];
          allowedUDPPorts = [ 53 6379 ];
        };

        system.stateVersion = "24.05";
      };
    };
  };
}
