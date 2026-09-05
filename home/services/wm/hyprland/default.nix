{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  quickshellConfig = "${config.xdg.configHome}/quickshell/classic";
  hyprlandEnabled = osConfig.programs.hyprland.enable;
in
{
  config = mkIf hyprlandEnabled {
    home.packages = with pkgs; [
      quickshell
      hyprls
    ];
    systemd.user.services = {
      quickshell = {
        Unit.Description = "Flexible toolkit for making desktop shells with QtQuick";
        Service.ExecStart = "${pkgs.quickshell}/bin/qs -p ${quickshellConfig}";
      };
      hyprpaper = {
        Unit.Description = "Wayland wallpaper utility";
        Service.ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      };
      waybar = {
        Unit.Description = "Highly customizable Wayland bar";
        Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      };
    };
  };
}
