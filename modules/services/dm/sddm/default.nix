{
  lib,
  config,
  ...
}:
with lib;
let
  hyprland = config.programs.hyprland;
in
{
  config = mkIf hyprland.enable {
    services.displayManager.sddm.enable = true;
    programs.silentSDDM = {
      theme = "catppuccin-mocha";
      enable = true;
    };
  };
}
