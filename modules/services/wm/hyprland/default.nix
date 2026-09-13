{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfgNvidia = config.hardware.nvidia;
  cfg = config.programs.hyprland;
in
{
  options.programs.hyprland.drmDevice = mkOption {
    description = "DRM device used by Hyprland.";
    default = "/dev/dri/card0";
    type = types.str;
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      xwayland.enable = true;
      withUWSM = true;
    };
    environment = with pkgs; {
      systemPackages = optionals cfgNvidia.enabled [ nvidia-vaapi-driver ];
      sessionVariables = {
        AQ_DRM_DEVICES = cfg.drmDevice;
        QT_QPA_PLATFORMTHEME = "qt6ct";
        NIXOS_OZONE_WL = "1";
      }
      // optionalAttrs cfgNvidia.enabled {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    };
  };
}
