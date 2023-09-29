{ pkgs, ... }:
with pkgs; {
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

  programs = {
    zsh.enable = true;
  };
}
