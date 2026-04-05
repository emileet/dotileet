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
        MONITOR1='DisplayPort-0'
        ${pkgs.xrandr}/bin/xrandr --output $MONITOR1 --mode 3440x1440 --rate 100 --primary
      '';
    };

    serverFlagsSection = ''
      Option "BlankTime" "0"
    '';

    monitorSection = ''
      Option "DPMS" "false"
    '';

    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';

    windowManager.i3.enable = true;
    autorun = true;
  };
}
