{ pkgs, ... }:
{
  users.users.emileet.packages = with pkgs; [
    spicetify-cli
    lxappearance
    pavucontrol
    autotiling
    lm_sensors
    vscode.fhs
    libnotify
    flameshot
    shotwell
    obsidian
    rnix-lsp
    hyfetch
    discord
    wezterm
    barrier
    bottom
    slack
    qt6ct
    dunst
    gimp
    tldr
    eza
    git
  ];
}
