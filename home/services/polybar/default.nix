{ lib, config, ... }:
with lib;
let
  cfg = config.services.polybar;
in
{
  config = mkIf cfg.enable {
    services.polybar.script = ''
      polybar bottom -c ~/.config/polybar/bottom.dp-0 &
      polybar top -c ~/.config/polybar/top.dp-0 &
      sleep 0.1
      polybar bottom -c ~/.config/polybar/bottom.dp-1 &
      polybar top -c ~/.config/polybar/top.dp-1 &
    '';

    home.file."${config.xdg.configHome}/polybar" = {
      source = ./config;
      recursive = true;
    };
  };
}
