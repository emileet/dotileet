{
  lib,
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
    services.polybar.script = ''
      polybar bottom -c ~/.config/polybar/bottom.dp-2 &
      polybar top -c ~/.config/polybar/top.dp-2 &
    '';

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
