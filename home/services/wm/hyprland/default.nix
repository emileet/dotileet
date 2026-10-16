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
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      quickshell
      hyprls
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
      awww.enable = true;
    };
    systemd.user.services = {
      quickshell = {
        Unit.Description = "Flexible toolkit for making desktop shells with QtQuick";
        Service.ExecStart = "${pkgs.quickshell}/bin/qs -p ${cfgQuickshell}";
      };
      awww.Service.ExecStartPost = map (
        wallpaper:
        escapeShellArgs (
          [
            (getExe config.services.awww.package)
            "img"
            "--resize"
            "crop"
          ]
          ++ optionals (wallpaper.monitor != "") [
            "--outputs"
            wallpaper.monitor
          ]
          ++ [ wallpaper.path ]
        )
      ) config.theme.wallpaper;
    };
  };
}
