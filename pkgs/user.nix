lib: pkgs: osConfig:
with lib;
with pkgs;
let
  graphical = osConfig.programs.hyprland.enable || osConfig.services.xserver.enable;
in
mkMerge [
  (mkIf graphical [
    qt6Packages.qt6ct
    moonlight-qt
    easyeffects
    qbittorrent
    libnotify
    flameshot
    shotwell
    wezterm
    dunst
    rofi
    vlc
    master.spicetify-cli
    master.vscode.fhs
    master.vesktop
  ])
  [
    ripgrep
    hyfetch
    bottom
    nixfmt
    direnv
    p7zip
    unzip
    file
    tldr
    eza
    git
    nil
  ]
]
