{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  hyprland = config.programs.hyprland;
in
{
  options.services.displayManager.sddm.hyprlandConfig = mkOption {
    type = types.lines;
    default = "";
    description = "lua configuration for hyprland under sddm";
  };

  config = mkIf hyprland.enable {
    environment = {
      systemPackages = with pkgs; [ catppuccin-cursors.mochaLight ];
      etc."sddm-hyprland.lua" = mkIf config.programs.hyprland.enable {
        text = config.services.displayManager.sddm.hyprlandConfig;
      };
    };

    services.displayManager.sddm = {
      settings = {
        Wayland.CompositorCommand = "start-hyprland -- -c /etc/sddm-hyprland.lua";
        Theme = {
          CursorTheme = "catppuccin-mocha-light-cursors"; # Replace with your exact cursor name
          CursorSize = "24";
        };
      };
      wayland.enable = true;
    };

    programs.silentSDDM = {
      profileIcons = {
        emileet = "/storage/pictures/avatars/emileet.jpg";
      };
      theme = "catppuccin-mocha";
      enable = true;
    };
  };
}
