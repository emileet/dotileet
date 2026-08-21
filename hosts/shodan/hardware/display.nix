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

    autorun = false;
    dpi = 96;
  };

  boot.kernelParams = optionals config.hardware.nvidia.enabled [
    "video=${monitor1}:5120x1440@240"
  ];

  environment = {
    etc."sddm-hyprland.lua" = mkIf config.programs.hyprland.enable {
      text = ''
        ${
          if config.hardware.nvidia.enabled then
            ''
              hl.monitor({
                  output = "HDMI-A-1",
                  mode = "5120x1440@240",
                  position = "0x0",
                  scale = 1,
              })
              hl.monitor({
                  output = "DP-1",
                  disabled = true,
              })
            ''
          else
            ''
              hl.monitor({
                  output = "DP-1",
                  mode = "5120x1440@240",
                  position = "0x0",
                  scale = 1,
              })
            ''
        }
        hl.config({
            misc = {
                disable_splash_rendering = true,
                disable_hyprland_logo = true,
                force_default_wallpaper = 0,
            },
        })
      '';
    };
    sessionVariables = mkIf config.services.xserver.windowManager.i3.enable {
      MONITOR1 = monitor1;
      MONITOR2 = monitor2;
    };
  };
}
