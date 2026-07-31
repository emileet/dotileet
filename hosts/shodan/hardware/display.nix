{
  config,
  pkgs,
  lib,
  ...
}:
let
  wallpaper = "/storage/pictures/wallpapers/mountain.jpg";
  monitor1 = "HDMI-0";
  monitor2 = "DP-0";
in
with lib;
{
  home-manager.users.emileet.theme.wallpaper = "${wallpaper}";

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
      setupCommands = ''
        ${pkgs.xrandr}/bin/xrandr --output ${monitor1} --mode 5120x1440 --rate 240 --primary
        ${pkgs.xrandr}/bin/xrandr --output ${monitor2} --mode 2560x1440 --rate 165 --rotate left --right-of ${monitor1}
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

  boot.kernelParams = optionals (config.specialisation != { }) [
    "video=${monitor1}:5120x1440@240"
  ];

  environment.sessionVariables = {
    MONITOR1 = monitor1;
    MONITOR2 = monitor2;
  };
}
