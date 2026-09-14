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
in
{
  options.theme = {
    profileIcon = mkOption {
      type = types.str;
      default = "";
      description = "profile icon path";
    };
    wallpaper = mkOption {
      type = types.str;
      default = "";
      description = "wallpaper path";
    };
  };
  config = mkIf graphical {
    theme.profileIcon = "/storage/pictures/avatars/emileet.jpg";
    theme.wallpaper = osConfig.theme.wallpaper;
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
