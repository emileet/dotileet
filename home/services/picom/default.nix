{ lib, config, ... }:
with lib;
let
  cfg = config.services.picom;
in
{
  config = mkIf cfg.enable {
    services.picom.settings = {
      unredir-if-possible = false;
      unredir-if-possible-exclude = [
        "class_g = 'i3lock'"
      ];

      corner-radius = 8;
      rounded-corners-exclude = [
        "class_g = 'mpv'"
        "class_g = 'Rofi'"
        "class_g = 'Polybar'"
        "class_g = 'i3-frame'"
        "class_g *= 'Lunar Client*'"
        "class_g = 'looking-glass-client'"
        "name = 'Notification area'"
      ];

      blur-background-frame = false;
      blur-background-fixed = true;
      blur-method = "dual_kawase";
      blur-background = true;
      blur-kern = "3x3box";
      blur-strength = 6;
      blur-background-exclude = [
        "class_g = 'mpv'"
        "class_g = 'firefox'"
        "class_g = 'Polybar'"
        "class_g = 'vmileet'"
        "class_g = 'flameshot'"
        "class_g *= 'Minecraft* 1'"
        "class_g *= 'Lunar Client*'"
        "class_g = 'looking-glass-client'"
        "window_type = 'desktop'"
      ];

      fading = true;
      fade-delta = 4;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      fade-exclude = [
        "class_g = 'vmileet'"
        "class_g *= 'Minecraft* 1'"
        "class_g = 'looking-glass-client'"
      ];

      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.75;
          focus = true;
        };
      };

      active-opacity = 1.0;
      frame-opacity = 1.0;

      shadow = false;

      glx-use-copysubbuffermesa = true;
      glx-no-rebind-pixmap = true;
      glx-copy-from-front = false;
      glx-no-stencil = true;

      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;

      mark-ovredir-focused = true;
      mark-wmwin-focused = true;

      xrender-sync-fence = true;
      use-damage = true;

      backend = "glx";
      vsync = true;
    };
  };
}
