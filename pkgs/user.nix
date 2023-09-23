{ pkgs, ... }:
{
  users.users.emileet.packages = with pkgs; [
    firefox-devedition
    spicetify-cli
    lxappearance
    pavucontrol
    autotiling
    lm_sensors
    vscode.fhs
    libnotify
    flameshot
    obsidian
    rnix-lsp
    hyfetch
    discord
    wezterm
    barrier
    bottom
    slack
    dunst
    gimp
    tldr
    rofi
    eza
    feh
    dex
    git
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        (callPackage ./kvmfr-obs { })
        obs-ndi
      ];
    })
  ];
}
