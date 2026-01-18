{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib;
let
  graphical = osConfig.services.xserver.enable;
in
{
  config = mkIf graphical {
    home = {
      pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaLight;
        name = "catppuccin-mocha-light-cursors";
        gtk.enable = true;
        x11.enable = true;
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
