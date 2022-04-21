{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.services.kmonad-mac;
in {
  options = {
    services.kmonad-mac = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the kmonad daemon.";
      };

      package = mkOption {
        type = types.package;
        description = "Specifies the kmonad package to use.";
      };

      environmentVariables = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Environment variables to make available for the launchd plist.";
      };

      keymap = mkOption {
        type = with types; either str path;
        description = "Path to the <filename>keymap.kdb</filename> configuration.";
      };
    };
  };

  config = mkIf cfg.enable {
    launchd.daemons.kmonad = {
      serviceConfig.ProgramArguments = [
        "${cfg.package}/bin/kmonad"
        "${cfg.keymap}"
      ];

      serviceConfig.RunAtLoad = true;
      serviceConfig.StandardOutPath = "/var/log/kmonad.out";
      serviceConfig.StandardErrorPath = "/var/log/kmonad.out";
      serviceConfig.EnvironmentVariables = lib.genAttrs cfg.environmentVariables builtins.getEnv;
      # serviceConfig.EnvironmentVariables = builtins.foldl' (res: x: res // { x = builtins.getEnv x; }) {} cfg.environmentVariables;
    };
  };
}
