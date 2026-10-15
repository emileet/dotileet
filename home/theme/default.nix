{
  lib,
  osConfig,
  ...
}:
with lib;
let
  hyprlandEnabled = osConfig.programs.hyprland.enable;
  x11Enabled = osConfig.services.xserver.enable;
  graphical = hyprlandEnabled || x11Enabled;
  hostName = osConfig.networking.hostName;
in
{
  options.theme = {
    profileIcon = mkOption {
      type = types.str;
      default = "";
      description = "profile icon path";
    };
    wallpaper = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = [ ];
      description = "per-monitor wallpaper entries";
    };
  };
  config = mkIf graphical {
    theme.profileIcon = "/storage/pictures/avatars/emileet.jpg";
    theme.wallpaper =
      if hostName == "shodan" then
        let
          nvidiaEnabled = osConfig.hardware.nvidia.enabled;
        in
        [
          {
            path = "/storage/pictures/wallpapers/kittyko-uw.jpg";
            fit_mode = "cover";
            monitor = if nvidiaEnabled then "HDMI-A-1" else "";
          }
          (mkIf nvidiaEnabled {
            path = "/storage/pictures/wallpapers/kittyko.jpg";
            fit_mode = "cover";
            monitor = "DP-1";
          })
        ]
      else
        [
          {
            path = osConfig.theme.wallpaper;
            fit_mode = "cover";
            monitor = "";
          }
        ];
    home = {
      pointerCursor = {
        package = osConfig.theme.pointerCursor.package;
        name = osConfig.theme.pointerCursor.name;
        hyprcursor.enable = hyprlandEnabled;
        x11.enable = x11Enabled;
        gtk.enable = true;
        enable = true;
      };
    };
    gtk = {
      cursorTheme = {
        package = osConfig.theme.pointerCursor.package;
        name = osConfig.theme.pointerCursor.name;
      };
      iconTheme = {
        package = osConfig.theme.gtk.iconTheme.package;
        name = osConfig.theme.gtk.iconTheme.name;
      };
      theme = {
        package = osConfig.theme.gtk.theme.package;
        name = osConfig.theme.gtk.theme.name;
      };
      colorScheme = "dark";
      enable = true;
    };
  };
}
