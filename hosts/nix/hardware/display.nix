{ pkgs, ... }:
{
  services.xserver = {
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
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

    libinput.enable = false;
    layout = "us";

    autorun = false;
    enable = true;
  };
}
