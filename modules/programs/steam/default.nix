{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfgVR = config.services.monado;
  cfg = config.programs.steam;
in
{
  config = mkIf cfg.enable {
    programs = {
      steam = {
        package = pkgs.steam.override {
          extraProfile = "unset TZ";
          extraEnv = {
            PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1"; # enables monado support
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

    services.monado.defaultRuntime = cfgVR.enable;
    systemd.user.services.monado.environment = mkIf cfgVR.enable {
      IPC_EXIT_ON_DISCONNECT = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      STEAMVR_LH_ENABLE = "1";
      WMR_HANDTRACKING = "0";
    };

    home-manager.users.emileet.home.packages = with pkgs; [
      (symlinkJoin {
        name = "lutris-wrapped";
        paths = [
          (lutris.override {
            extraPkgs = pkgs: [
              wineWow64Packages.stable
              vulkan-tools
              gamemode
              mangohud
            ];
          })
        ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/lutris \
            --prefix GI_TYPELIB_PATH : "${libayatana-appindicator}/lib/girepository-1.0"
        '';
      })
    ];
  };
}
