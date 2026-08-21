{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib;
let
  hyprlandEnabled = osConfig.programs.hyprland.enable;
in
{
  config = mkIf hyprlandEnabled {
    home.packages = with pkgs; [
      hyprls
    ];
    systemd.user.services = {
      hyprpaper = {
        Unit.Description = "Wayland wallpaper utility";
        Service = {
          Type = "simple";
          Restart = "no";
          ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        };
      };
      waybar = {
        Unit.Description = "Highly customizable Wayland bar";
        Service = {
          Type = "simple";
          Restart = "no";
          ExecStart = "${pkgs.waybar}/bin/waybar";
        };
      };
    };
  };
}
