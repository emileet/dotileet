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
    obsidian
    rnix-lsp
    hyfetch
    discord
    wezterm
    barrier
    bottom
    vscode
    slack
    dunst
    gimp
    tldr
    rofi
    feh
    dex
    git
  ];
}
