{
  config,
  pkgs,
  lib,
  ...
}:
let
  wallpaper = "/storage/pictures/wallpapers/mountain.jpg";
in
with lib;
{
  home-manager.users.emileet.theme.wallpaper = "${wallpaper}";

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
      setupCommands = ''
        MONITOR1='HDMI-0'
        MONITOR2='DP-0'
        ${pkgs.xrandr}/bin/xrandr --output $MONITOR1 --mode 5120x1440 --rate 240 --primary
        ${pkgs.xrandr}/bin/xrandr --output $MONITOR2 --mode 2560x1440 --rate 165 --rotate left --right-of $MONITOR1
      '';
    };

    serverFlagsSection = ''
      Option "BlankTime" "0"
    '';

    monitorSection = ''
      Option "DPMS" "false"
    '';

    videoDrivers = optionals (config.specialisation != { }) [
      "nvidia"
    ];

    windowManager.i3.enable = true;
    autorun = true;
    dpi = 96;
  };
}
