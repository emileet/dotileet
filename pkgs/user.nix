lib: pkgs: osConfig:
with lib;
with pkgs;
let
  graphical = osConfig.services.xserver.enable;
in
mkMerge [
  (mkIf graphical [
    catppuccin-cursors.mochaLight
    papirus-icon-theme
    colloid-gtk-theme
    lxappearance
    libnotify
    flameshot
    shotwell
    deskflow
    wezterm
    qt6ct
    dunst
    slack
    vlc
    master.spicetify-cli
    master.vscode.fhs
    master.vesktop
  ])
  ([
    nixfmt-rfc-style
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
