{ lib, graphical, ... }:
with lib; {
  imports = (import ./services);
  home.stateVersion = "23.11";

  services = {
    picom = mkIf graphical {
      enable = true;
    };
    polybar = mkIf graphical {
      enable = true;
    };
  };
}
