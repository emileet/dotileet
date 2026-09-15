{
  lib,
  pkgs,
  config,
  ...
}:
with pkgs;
with lib;
let
  hyprlandEnabled = config.programs.hyprland.enable;
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
      extraPortals = optionals hyprlandEnabled [ xdg-desktop-portal-hyprland ] ++ [
        xdg-desktop-portal-gtk
      ];
      config.common.default = optionals hyprlandEnabled [ "hyprland" ] ++ [ "gtk" ];
      enable = true;
    };
  };
}
