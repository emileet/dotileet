{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = osConfig.programs.hyprland;
  cfgQuickshell = "${config.xdg.configHome}/quickshell/classic";
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
              ignore_inhibit = true;
              timeout = 600;
            }
          ];
        };
        systemdTarget = "graphical-session.target";
        enable = true;
      };
      hyprpaper = {
        settings = {
          wallpaper = [
            {
              path = "${config.theme.wallpaper}";
              fit_mode = "cover";
              monitor = "";
            }
          ];
          splash = false;
        };
        systemdTarget = "graphical-session.target";
        enable = true;
      };
    };
    systemd.user.services = {
      quickshell = {
        Unit.Description = "Flexible toolkit for making desktop shells with QtQuick";
        Service.ExecStart = "${pkgs.quickshell}/bin/qs -p ${cfgQuickshell}";
      };
      waybar = {
        Unit.Description = "Highly customizable Wayland bar";
        Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      };
    };
  };
}
