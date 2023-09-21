{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.mochaLight
    catppuccin-gtk
    nix-diff
    pciutils
    killall
    polybar
    picom
    htop
    wget
    vim
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk
    sf-mono-liga
    font-awesome
    tamzen
    siji
  ];
}
