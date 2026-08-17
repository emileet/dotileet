{
  lib,
  config,
  ...
}:
with lib;
let
  i3 = config.services.xserver.windowManager.i3;
  hyprland = config.programs.hyprland;
in
{
  config = mkIf (i3.enable && !hyprland.enable) {
    services.xserver.displayManager.lightdm = {
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
}
