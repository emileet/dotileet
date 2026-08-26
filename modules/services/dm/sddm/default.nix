{
  lib,
  config,
  ...
}:
with lib;
let
  homeCfg = config.home-manager.users.emileet;
  hyprland = config.programs.hyprland;
in
{
  options.services.displayManager.sddm.hyprlandConfig = mkOption {
    type = types.lines;
    default = "";
    description = "lua configuration for hyprland under sddm";
  };

  config = mkIf hyprland.enable {
    environment.etc."sddm-hyprland.lua" = mkIf config.programs.hyprland.enable {
      text = config.services.displayManager.sddm.hyprlandConfig;
    };

    services.displayManager.sddm = {
      settings = {
        Wayland.CompositorCommand = "start-hyprland -- -c /etc/sddm-hyprland.lua";
        Theme = {
          CursorTheme = homeCfg.home.pointerCursor.name;
          CursorSize = "24";
        };
      };
      wayland.enable = true;
    };

    programs.silentSDDM = {
      backgrounds.wallpaper = /. + homeCfg.theme.wallpaper;
      profileIcons.emileet = homeCfg.theme.profileIcon;
      theme = "default";
      enable = true;
      settings =
        let
          wallpaperFileName = baseNameOf homeCfg.theme.wallpaper;
        in
        {
          "LoginScreen".background = wallpaperFileName;
          "LockScreen".background = wallpaperFileName;
        };
    };
  };
}
