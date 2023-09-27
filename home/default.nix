{ lib, osConfig, ... }:
with lib;
let
  wm = osConfig.services.xserver.windowManager;
in
{
  imports = (import ./services);
  home.stateVersion = "23.11";

  services = { } // mkIf wm.i3.enable {
    polybar.enable = true;
    picom.enable = true;
  };

  xsession = {
    windowManager.i3 = mkIf wm.i3.enable {
      enable = true;
    };
  };
}
