{ lib, config, ... }:
with lib;
let
  nvidiaEnabled = config.hardware.nvidia.enabled;
in
{
  home-manager.users.emileet.theme = {
    wallpaper = [
      {
        path = "/storage/pictures/wallpapers/kittyko-uw.jpg";
        fit_mode = "cover";
        monitor = if nvidiaEnabled then "HDMI-A-1" else "";
      }
      (mkIf nvidiaEnabled {
        path = "/storage/pictures/wallpapers/kittyko.jpg";
        fit_mode = "cover";
        monitor = "DP-1";
      })
    ];
  };
}
