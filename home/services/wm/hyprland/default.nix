{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfgQuickshell = "${config.xdg.configHome}/quickshell/island";
  cfg = osConfig.programs.hyprland;
in
{
  options.services.hypridle.autoStart = mkOption {
    type = types.bool;
    default = true;
    description = "Whether hypridle should start automatically with the graphical session.";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      quickshell
      hyprls
      satty
      slurp
      grim
    ];
    services = {
      hypridle = {
        settings = {
          listener = [
            {
              on-timeout = "sh -c 'hyprctl dispatch \"hl.dsp.dpms({ action = \\\"disable\\\", monitor = \\\"$WMONITOR1\\\" })\"'";
              on-resume = "sh -c 'hyprctl dispatch \"hl.dsp.dpms({ action = \\\"enable\\\", monitor = \\\"$WMONITOR1\\\" })\"'";
              ignore_inhibit = false;
              timeout = 600;
            }
          ];
        };
        systemdTarget = "graphical-session.target";
        enable = true;
      };
    };
    systemd.user.services = {
      hypridle.Install.WantedBy = mkIf (!config.services.hypridle.autoStart) (mkForce [ ]);
      quickshell = {
        Unit.Description = "Flexible toolkit for making desktop shells with QtQuick";
        Service.ExecStart = "${pkgs.quickshell}/bin/qs -p ${cfgQuickshell}";
      };
    };
  };
}
