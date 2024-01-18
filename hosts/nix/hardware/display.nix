{ pkgs, ... }:
let
  wallpaper = "/storage/pictures/wallpapers/nightsky-raw.jpg";
in
{
  home-manager.users.emileet.xsession.windowManager.i3.wallpaper = "${wallpaper}";

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
      setupCommands = ''
        MONITOR='DisplayPort-0'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $MONITOR --primary --mode 5120x1440 --rate 240
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
