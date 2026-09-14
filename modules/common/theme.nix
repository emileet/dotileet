{
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.theme = {
    wallpaper = mkOption {
      type = types.str;
      default = "/storage/pictures/wallpapers/mountain.jpg";
      description = "System wallpaper path.";
    };

    pointerCursor = {
      package = mkOption {
        type = types.package;
        default = pkgs.catppuccin-cursors.mochaLight;
        description = "System cursor package.";
      };

      name = mkOption {
        type = types.str;
        default = "catppuccin-mocha-light-cursors";
        description = "System cursor theme name.";
      };

      size = mkOption {
        type = types.int;
        default = 24;
        description = "System cursor size.";
      };
    };

    gtk = {
      iconTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.papirus-icon-theme;
          description = "System GTK icon theme package.";
        };

        name = mkOption {
          type = types.str;
          default = "Papirus-Dark";
          description = "System GTK icon theme name.";
        };
      };

      theme = {
        package = mkOption {
          type = types.package;
          default = pkgs.colloid-gtk-theme;
          description = "System GTK theme package.";
        };

        name = mkOption {
          type = types.str;
          default = "Colloid-Purple-Dark-Compact-Dracula";
          description = "System GTK theme name.";
        };
      };
    };
  };
}
