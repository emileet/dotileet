{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.xserver.windowManager.i3;
in
{
  config = mkIf cfg.enable {
    services = {
      xserver = {
        windowManager.i3 = {
          extraSessionCommands = ''
            eval $(gnome-keyring-daemon --daemonize)
            export SSH_AUTH_SOCK
          '';
          package = pkgs.i3;
        };

        desktopManager.xterm.enable = false;
        xkb.layout = "us";
        enable = true;
      };

      libinput.enable = false;
    };

    xdg.portal = mkIf config.services.flatpak.enable {
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
      enable = true;
    };
  };
}
