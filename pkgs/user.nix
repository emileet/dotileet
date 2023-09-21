{ pkgs, ... }:
{
  users.users.emileet.packages = with pkgs; [
    firefox-devedition
    lxappearance
    pavucontrol
    autotiling
    lm_sensors
    rnix-lsp
    neofetch
    discord
    wezterm
    barrier
    bottom
    vscode
    slack
    tldr
    rofi
    feh
    dex
    git
  ];
}
