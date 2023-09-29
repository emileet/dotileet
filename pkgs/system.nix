{ lib, pkgs, config, ... }:
with pkgs; with lib;
let
  graphical = config.services.xserver.enable;
in
{
  environment.systemPackages = [
    catppuccin-cursors.mochaLight
    catppuccin-gtk
    papirus-icon-theme
    lm_sensors
    nix-diff
    pciutils
    htop
    wget
    vim
  ];

  fonts.packages = [
    noto-fonts-cjk
    sf-mono-liga
    font-awesome
    tamzen
    siji
  ];

  programs = mkMerge [
    (mkIf graphical {
      firefox.enable = true;
      thunar.enable = true;
      dconf.enable = true;
    })
    ({
      gnupg.agent = {
        enableSSHSupport = true;
        enable = true;
      };

      neovim = {
        defaultEditor = true;
        enable = true;
      };

      zsh.enable = true;
    })
  ];
}
