{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.vban;
in
{
  options.services.vban = {
    enable = mkEnableOption "vban";

    emitter = {
      enable = mkEnableOption "emitter";

      stream = mkOption {
        type = types.str;
        default = "Audio";
        description = "stream name";
      };

      ip = mkOption {
        type = types.str;
        default = "";
        description = "emitter ip";
      };

      port = mkOption {
        type = types.int;
        default = 6980;
        description = "emitter port";
      };
    };

    receptor = {
      enable = mkEnableOption "receptor";

      stream = mkOption {
        type = types.str;
        default = "Microphone";
        description = "stream name";
      };

      ip = mkOption {
        type = types.str;
        default = "";
        description = "receptor ip";
      };

      port = mkOption {
        type = types.int;
        default = 6980;
        description = "receptor port";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      vban-emitter = mkIf cfg.emitter.enable {
        description = "vban-emitter";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session-pre.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.vban}/bin/vban_emitter -i ${cfg.emitter.ip} -p ${toString cfg.emitter.port} -s ${cfg.emitter.stream} -r 48000";
          Restart = "on-failure";
          TimeoutStopSec = 10;
          RestartSec = 1;
        };
      };

      vban-receptor = mkIf cfg.receptor.enable {
        description = "vban-receptor";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session-pre.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.vban}/bin/vban_receptor -i ${cfg.emitter.ip} -p ${toString cfg.emitter.port} -s ${cfg.receptor.stream} -q 2";
          Restart = "on-failure";
          TimeoutStopSec = 10;
          RestartSec = 1;
        };
      };
    };
  };
}
