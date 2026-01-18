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
        MONITOR='DisplayPort-0'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $MONITOR --primary --mode 3440x1440 --rate 100
      '';
    };

    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';

    windowManager.i3.enable = true;
    autorun = true;
  };
}
