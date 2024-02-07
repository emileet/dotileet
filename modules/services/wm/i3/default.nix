{ lib, pkgs, config, ... }:
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
          package = pkgs.i3-gaps;
        };

        displayManager = {
          defaultSession = "none+i3";
          lightdm = {
            greeters.mini = {
              extraConfig = ''
                [greeter]
                show-password-label = false
                password-input-width = 28
                [greeter-theme]
                background-color = "#000000"
                window-color = "#1e1e2e"
                border-color = "#11111b"
                border-width = 1px
                password-background-color = "#313244"
                password-border-color = "#11111b"
                password-border-width = 1px
                password-color = "#cdd6f4"
                error-color = "#f38ba8"
                text-color = "#cdd6f4"
              '';
              user = "emileet";
              enable = true;
            };
            enable = true;
          };
        };

        desktopManager.xterm.enable = false;
        libinput.enable = false;
        xkb.layout = "us";
        enable = true;
      };

      gnome.gnome-keyring.enable = true;
    };

    xdg.portal = mkIf config.services.flatpak.enable {
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
      enable = true;
    };
  };
}
