{ pkgs, ... }:
{
  services.xserver = {
    displayManager = {
      lightdm.background = "/storage/pictures/wallpapers/nightsky-2560.jpg";
      setupCommands = ''
        LEFT='DisplayPort-1'
        RIGHT='DisplayPort-0'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --mode 2560x1440 --rate 165 --primary --output $RIGHT --mode 2560x1440 --rate 165 --right-of $LEFT
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
