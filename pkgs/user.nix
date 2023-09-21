{ pkgs, ... }:
{
  users.users.emileet.packages = with pkgs; [
    firefox-devedition
    lxappearance
    pavucontrol
    autotiling
    lm_sensors
    libnotify
    flameshot
    rnix-lsp
    hyfetch
    discord
    wezterm
    barrier
    bottom
    vscode
    slack
    dunst
    tldr
    rofi
    feh
    dex
    git
  ];
}
