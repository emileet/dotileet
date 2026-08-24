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
  config = mkIf cfg.enable {
    programs.hyprland = {
      xwayland.enable = true;
      withUWSM = true;
    };
    environment = with pkgs; {
      systemPackages = optionals cfgNvidia.enabled [ nvidia-vaapi-driver ];
      sessionVariables = {
        AQ_DRM_DEVICES = "/dev/dri/card1";
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
