{ pkgs, config, ... }:
let
  wallpaper = config.home-manager.users.emileet.theme.wallpaper;
in
{

  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
      setupCommands = ''
        XMONITOR1='DisplayPort-0'
        ${pkgs.xrandr}/bin/xrandr --output $XMONITOR1 --mode 3440x1440 --rate 100 --primary
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
