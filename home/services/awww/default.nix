{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfgAwwwCache = "${config.xdg.cacheHome}/awww-${if cfgNvidia.enabled then "nvidia" else "amdgpu"}";
  cfgNvidia = osConfig.hardware.nvidia;
  cfg = osConfig.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    services.awww.enable = true;
    home = {
      file."${config.xdg.cacheHome}/awww".source = config.lib.file.mkOutOfStoreSymlink cfgAwwwCache;
      activation.awwwCache = hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.coreutils}/bin/mkdir -p ${escapeShellArg cfgAwwwCache}
      '';
    };
    systemd.user.services.awww.Service.ExecStartPost = map (
      wallpaper:
      escapeShellArgs (
        [
          (getExe config.services.awww.package)
          "img"
          "--resize"
          "crop"
        ]
        ++ optionals (wallpaper.monitor != "") [
          "--outputs"
          wallpaper.monitor
        ]
        ++ [ wallpaper.path ]
      )
    ) config.theme.wallpaper;
  };
}
