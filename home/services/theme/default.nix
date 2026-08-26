{
  lib,
  pkgs,
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
    theme.wallpaper = "/storage/pictures/wallpapers/mountain.jpg";
    theme.profileIcon = "/storage/pictures/avatars/emileet.jpg";
    home = {
      pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaLight;
        name = "catppuccin-mocha-light-cursors";
        hyprcursor.enable = hyprlandEnabled;
        x11.enable = x11Enabled;
        gtk.enable = true;
        enable = true;
      };
    };
    gtk = {
      cursorTheme = {
        package = pkgs.catppuccin-cursors.mochaLight;
        name = "catppuccin-mocha-light-cursors";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      theme = {
        package = pkgs.colloid-gtk-theme;
        name = "Colloid-Purple-Dark-Compact-Dracula";
      };
      colorScheme = "dark";
      enable = true;
    };
  };
}
