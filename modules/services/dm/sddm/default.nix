{
  lib,
  config,
  ...
}:
with lib;
let
  enabledKeyring = config.services.wm.common.enableKeyring;
  homeCfg = config.home-manager.users.emileet;
  hyprland = config.programs.hyprland;
  theme = config.theme;
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
          CursorSize = toString theme.pointerCursor.size;
          CursorTheme = theme.pointerCursor.name;
        };
      };
      wayland.enable = true;
    };

    programs.silentSDDM = {
      profileIcons.emileet = homeCfg.theme.profileIcon;
      backgrounds.wallpaper = /. + theme.wallpaper;
      theme = "default";
      enable = true;
      settings =
        let
          wallpaperFileName = baseNameOf theme.wallpaper;
        in
        {
          "LoginScreen".background = wallpaperFileName;
          "LockScreen".background = wallpaperFileName;
        };
    };

    security.pam.services.sddm.enableGnomeKeyring = enabledKeyring;
  };
}
