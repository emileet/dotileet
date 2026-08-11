{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.services.polybar;
  hostName = osConfig.networking.hostName;
in
{
  config = mkIf cfg.enable {
    services.polybar.script =
      if (hostName == "shodan") then
        with pkgs;
        let
          HWMON_PATH = "/sys/bus/pci/drivers/k10temp/0000:*/hwmon/hwmon*/temp1_input";
        in
        ''
          export HWMON_PATH=$(${coreutils}/bin/ls ${HWMON_PATH} 2>/dev/null | ${coreutils}/bin/head -n 1)
          polybar bottom -c ~/.config/polybar/bottom.1 &
          polybar bottom -c ~/.config/polybar/bottom.2 &
          polybar top -c ~/.config/polybar/top.1 &
          polybar top -c ~/.config/polybar/top.2 &
        ''
      else if (hostName == "nix") then
        ''
          polybar bottom -c ~/.config/polybar/bottom.1 &
          polybar top -c ~/.config/polybar/top.1 &
        ''
      else
        abort "missing polybar script for host: ${hostName}";

    # have our window manager start the polybar service
    systemd.user.services.polybar = {
      Install.WantedBy = mkForce [ ];
      Unit.PartOf = mkForce [ ];
    };

    home.file."${config.xdg.configHome}/polybar" = {
      source =
        if (hostName == "shodan") then
          ./config/shodan
        else if (hostName == "nix") then
          ./config/nix
        else
          abort "missing polybar config for host: ${hostName}";
      recursive = true;
    };
  };
}
