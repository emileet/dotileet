{ pkgs, ... }:
let
  wallpaper = "/storage/pictures/wallpapers/nightsky-2560.jpg";
in
{
  services.xserver = {
    displayManager = {
      lightdm.background = "${wallpaper}";
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

  home-manager.users.emileet.xsession.windowManager.i3 = {
    wallpaper = "${wallpaper}";
    config =
      let
        ws1 = "1:一";
        ws2 = "2:二";
        ws3 = "3:三";
        ws4 = "4:四";
        ws5 = "5:五";
        ws6 = "6:六";
        ws7 = "7:七";
        ws8 = "8:八";
        ws9 = "9:九";
        ws10 = "10:十";
      in
      {
        workspaceOutputAssign = [
          { workspace = "${ws1}"; output = "DisplayPort-0"; }
          { workspace = "${ws2}"; output = "DisplayPort-0"; }
          { workspace = "${ws8}"; output = "DisplayPort-1"; }
          { workspace = "${ws9}"; output = "DisplayPort-1"; }
          { workspace = "${ws10}"; output = "DisplayPort-1"; }
        ];
      };
  };
}
