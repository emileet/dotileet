{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.wave3-daemon;
in
{
  options.services.wave3-daemon = {
    startGain = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "initial gain percentage of microphone (0-100)";
    };
    startMuted = mkOption {
      type = types.bool;
      default = false;
      description = "initial mute state of microphone";
    };
    syncPipewire = mkOption {
      type = types.bool;
      default = false;
      description = "sync changes between the daemon and pipewire";
    };
    enable = mkEnableOption "wave3-daemon";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wave3-daemon ];

    systemd.user.services = {
      wave3-daemon = {
        description = "Elgato Wave:3 userspace daemon";
        wantedBy = [ "wireplumber.service" ];
        after = [ "wireplumber.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.wave3-daemon}/bin/wave3-daemon${
            if cfg.syncPipewire then " --sync-pipewire" else ""
          }";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      wave3-start-config = {
        description = "Elgato Wave:3 startup configuration";
        wantedBy = [ "wave3-daemon.service" ];
        after = [ "wave3-daemon.service" ];
        script = ''
          ${if cfg.startMuted then "${pkgs.wave3-daemon}/bin/wave3ctl mute on" else ""}
          ${
            if cfg.startGain != null then
              "${pkgs.wave3-daemon}/bin/wave3ctl gain " + toString cfg.startGain
            else
              ""
          }
        '';
        serviceConfig = {
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          RemainAfterExit = true;
          Type = "oneshot";
        };
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0070", MODE="0660", GROUP="audio", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0071", MODE="0660", GROUP="audio", TAG+="uaccess"
    '';
  };
}
