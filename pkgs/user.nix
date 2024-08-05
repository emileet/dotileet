lib: pkgs: osConfig:
with lib; with pkgs;
let
  graphical = osConfig.services.xserver.enable;
in
mkMerge [
  (mkIf graphical [
    catppuccin-cursors.mochaLight
    papirus-icon-theme
    colloid-gtk-theme
    spicetify-cli
    lxappearance
    vscode.fhs
    libnotify
    flameshot
#    obsidian
    shotwell
#    discord
    vesktop
    wezterm
    barrier
    qt6ct
    dunst
    slack
    vlc
  ])
  ([
    hyfetch
    bottom
    direnv
    p7zip
    unzip
    file
    tldr
    eza
    git
    nil
  ])
]
