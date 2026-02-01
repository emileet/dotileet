{ pkgs, ... }:
let
  wallpaper = "/storage/pictures/wallpapers/sunset.jpg";
in
{
  home-manager.users.emileet.theme.wallpaper = "${wallpaper}";

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
      setupCommands = ''
        MONITOR='DP-2'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $MONITOR --primary --mode 5120x1440 --rate 240
      '';
    };

    serverFlagsSection = ''
      Option "BlankTime" "0"
    '';

    monitorSection = ''
      Option "DPMS" "false"
    '';

    videoDrivers = [ "nvidia" ];

    windowManager.i3.enable = true;
    autorun = true;
    dpi = 96;
  };
}
