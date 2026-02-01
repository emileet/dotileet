{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = osConfig.services.monado;
in
{
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ wayvr ];
      file = {
        "${config.xdg.configHome}/openxr/1/active_runtime.json".source =
          "${pkgs.monado}/share/openxr/1/openxr_monado.json";
        "${config.xdg.configHome}/openvr/openvrpaths.vrpath".text =
          let
            steam = "${config.xdg.dataHome}/Steam";
          in
          builtins.toJSON {
            config = [ "${steam}/config" ];
            log = [ "${steam}/logs" ];
            external_drivers = null;
            jsonid = "vrpathreg";
            version = 1;
            runtime = [
              "${pkgs.opencomposite}/lib/opencomposite"
            ];
          };
      };
    };
  };
}
