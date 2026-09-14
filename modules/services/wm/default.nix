{
  lib,
  config,
  ...
}:
with lib;
let
  i3Enabled = config.services.xserver.windowManager.i3.enable;
  hyprlandEnabled = config.programs.hyprland.enable;
  graphical = i3Enabled || hyprlandEnabled;
  cfg = config.services.wm.common;
in
{
  imports = [
    ./hyprland
    ./i3
  ];

  options.services.wm.common = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shared graphical settings for all configured window managers.";
    };

    enableKeyring = mkOption {
      type = types.bool;
      default = true;
      description = "Enable gnome-keyring when a supported window manager is enabled.";
    };
  };

  config = mkIf (graphical && cfg.enable) {
    services.gnome.gnome-keyring.enable = cfg.enableKeyring;
    environment.systemPackages = [
      config.theme.pointerCursor.package
      config.theme.gtk.iconTheme.package
      config.theme.gtk.theme.package
    ];
  };
}
