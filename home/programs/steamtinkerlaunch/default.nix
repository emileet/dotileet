{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = osConfig.programs;
in
{
  config = mkIf cfg.steam.enable {
    home.packages = [ pkgs.master.steamtinkerlaunch ];

    xdg.dataFile = {
      "Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source =
        config.lib.file.mkOutOfStoreSymlink "${pkgs.master.steamtinkerlaunch}/bin/steamtinkerlaunch";
      "Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf".text = ''
        "manifest"
        {
          "commandline" "/steamtinkerlaunch run"
          "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
        }
      '';
      "Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf".text = ''
        "compatibilitytools"
        {
          "compat_tools"
          {
            "Proton-stl" // Internal name of this tool
            {
              "install_path" "."
              "display_name" "Steam Tinker Launch"
              "from_oslist"  "windows"
              "to_oslist"    "linux"
            }
          }
        }
      '';
    };
  };
}
