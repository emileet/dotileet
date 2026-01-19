{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.steam;
in
{
  config = mkIf cfg.enable {
    programs = {
      steam = {
        package = pkgs.steam.override {
          extraEnv = {
            GDK_PIXBUF_MODULE_FILE = ""; # fixes tray icon when launched from rofi
          };
        };
        extraPackages = with pkgs; [
          gamemode
          mangohud
          usbutils
        ];
      };
      gamemode = {
        settings.general.inhibit_screensaver = 0;
        enableRenice = true;
        enable = true;
      };
    };
    home-manager.users.emileet.home.packages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [
          wineWowPackages.stable
          gamemode
          mangohud
        ];
      })
    ];
  };
}
