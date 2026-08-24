{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  pipewireEnabled = config.services.pipewire.enable;
  cfg = config.hardware.wave3;
in
{
  options.hardware.wave3 = {
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
    enable = mkEnableOption "support for the Elgato Wave:3 microphone";
  };

  config = mkIf (cfg.enable && pipewireEnabled) {
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

    services = {
      pipewire = {
        wireplumber = {
          extraScripts."wave3fix.lua" = builtins.readFile ./wireplumber/fix.lua;
          extraConfig."51-wave3" = import ./wireplumber;
        };
      };
      udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0070", MODE="0660", GROUP="audio", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0071", MODE="0660", GROUP="audio", TAG+="uaccess"
      '';
    };
  };
}
