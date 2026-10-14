{
  lib,
  config,
  osConfig,
  ...
}:
with lib;
let
  gtk4ThemeName = replaceStrings [ "-Dark-" ] [ "-" ] osConfig.theme.gtk.theme.name;
  cfg = config.programs.ghostty;
in
{
  config = mkIf cfg.enable {
    programs.ghostty = {
      enableZshIntegration = true;
      systemd.enable = true;
      settings = {
        shell-integration-features = "no-cursor";
        cursor-style-blink = false;
        cursor-style = "block";

        font-family = "Liga SFMono Nerd Font";
        font-style = "Medium";
        font-size = 10;

        cursor-color = "#eeffff";
        foreground = "#eeffff";
        background = "#100d1f";
        background-opacity = 0.6;
        bold-color = "bright";
        palette = [
          "0=#1d1f2b"
          "1=#f37fad"
          "2=#529aff"
          "3=#f2a272"
          "4=#8890ff"
          "5=#c574dd"
          "6=#af97ff"
          "7=#eeffff"
          "8=#af97ff"
          "9=#c574dd"
          "10=#18e3c8"
          "11=#ff4971"
          "12=#556fff"
          "13=#b043d1"
          "14=#79e6f3"
          "15=#bebec1"
        ];

        quit-after-last-window-closed = false;
        window-show-tab-bar = "never";
        window-padding-x = 20;
        window-padding-y = 20;
        gtk-custom-css = [
          "${osConfig.theme.gtk.theme.package}/share/themes/${gtk4ThemeName}/gtk-4.0/gtk-dark.css"
        ];
      };
    };
    xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service" =
      mkIf cfg.systemd.enable
        {
          source = "${cfg.package}/share/systemd/user/app-com.mitchellh.ghostty.service";
        };
  };
}
