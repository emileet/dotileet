{
  config,
  pkgs,
  lib,
  ...
}:
let
  wallpaper = "/storage/pictures/wallpapers/sunset.jpg";
in
with lib;
{
  home-manager.users.emileet.theme.wallpaper = "${wallpaper}";

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
     setupCommands = ''
       MONITOR='HDMI-1'
       ${pkgs.xrandr}/bin/xrandr --output $MONITOR --primary --mode 5120x1440 --rate 240
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
