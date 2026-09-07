{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfgNvidia = config.hardware.nvidia;

  wmonitor1 = if cfgNvidia.enabled then "HDMI-A-1" else "DP-1";
  wmonitor2 = if cfgNvidia.enabled then "DP-1" else "";

  xmonitor1 = "HDMI-0";
  xmonitor2 = "DP-0";
in
with lib;
{
  services = {
    xserver = {
      displayManager = {
        lightdm.background = "${config.home-manager.users.emileet.theme.wallpaper}";
        setupCommands = ''
          ${pkgs.xrandr}/bin/xrandr --output ${xmonitor1} --mode 5120x1440 --rate 240 --primary
          ${pkgs.xrandr}/bin/xrandr --output ${xmonitor2} --mode 2560x1440 --rate 165 --rotate left --right-of ${xmonitor1}
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
    displayManager.sddm.hyprlandConfig = ''
      ${
        ''
          hl.monitor({
            output = "${wmonitor1}",
            mode = "5120x1440@240",
            position = "auto-left",
            scale = 1,
          })
        ''
        + optionalString cfgNvidia.enabled ''
          hl.monitor({
              output = "${wmonitor2}",
              disabled = true,
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

  boot.kernelParams = optionals cfgNvidia.enabled [
    "video=${wmonitor1}:5120x1440@240"
  ];

  environment.sessionVariables = mkMerge [
    (mkIf config.programs.hyprland.enable {
      WMONITOR1 = wmonitor1;
      WMONITOR2 = wmonitor2;
    })
    (mkIf config.services.xserver.windowManager.i3.enable {
      XMONITOR1 = xmonitor1;
      XMONITOR2 = xmonitor2;
    })
  ];
}
