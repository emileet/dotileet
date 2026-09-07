{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfgNvidia = osConfig.hardware.nvidia;
  cfgHyprland = osConfig.programs.hyprland;
  cfgQuickshell = "${config.xdg.configHome}/quickshell/classic";
  idleMonitor = if cfgNvidia.enabled then "HDMI-A-1" else "DP-1";
in
{
  config = mkIf cfgHyprland.enable {
    home.packages = with pkgs; [
      quickshell
      hyprls
    ];
    services = {
      hypridle = {
        settings = {
          listener = [
            {
              on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\", monitor = \"${idleMonitor}\" })'";
              on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\", monitor = \"${idleMonitor}\" })'";
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
